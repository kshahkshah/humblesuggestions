# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  authentication_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  netflix_user_id        :string(255)
#  netflix_token          :string(255)
#  netflix_secret         :string(255)
#  instapaper_user_id     :string(255)
#  instapaper_token       :string(255)
#  instapaper_secret      :string(255)
#  name                   :string(255)
#  netflix_status         :string(255)
#  instapaper_status      :string(255)
#  last_location          :string(255)
#  last_latitude          :string(255)
#  last_longitude         :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
         :rememberable, :trackable, :token_authenticatable

  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true, :if => :email_changed?
  validates_format_of :email, :with => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validate :check_signup_code

  # Setup accessible (or protected) attributes for your model
  attr_accessor :signup_code
  attr_accessible :name, :email, :password, :remember_me, :signup_code
  # attr_accessible :title, :body

  LIST_OF_SERVICES = ['netflix', 'instapaper']

  after_create Proc.new {|u| UserMailer.welcome_email(u).deliver }

  has_many :content_items

  def self.find_or_create_from_auth_hash(auth_hash)
    # first check if we have that user via that provider...
    @user = User.where("#{auth_hash.provider}_user_id" => auth_hash.uid).first
    return @user if @user

    # can't find one, but what if they are connecting a different service and already have an account?
    # well, do a look up by email first then merge the accounts
    if @user = User.where(email: auth_hash.info.email).first
      @user.add_service_from_auth_hash(auth_hash)
    end
    # then return the user...
    return @user if @user

    # snap, still no user, well then welcome aboard...
    @user = User.new({
      email: auth_hash.info.email,
      name:  auth_hash.info.name
    }).add_service_from_auth_hash(auth_hash)
    return @user if @user

  end

  # this should be a private method...
  def add_service_from_auth_hash(auth_hash)
    self.email = auth_hash.info.email if self.email.blank?
    self.send("#{auth_hash.provider}_user_id=", auth_hash.uid)
    self.send("#{auth_hash.provider}_token=", auth_hash.credentials.token)
    self.send("#{auth_hash.provider}_secret=", auth_hash.credentials.secret)
    self.save
    self.send("process_#{auth_hash.provider}_queue")
  end

  def display_name
    name.blank? ? email.split("@").first : name.split(" ").first rescue "friend"
  end

  def connected?
    netflix_connected? or instapaper_connected?
  end

  def connecting_to_services?
    LIST_OF_SERVICES.map{|service| self.send(service + '_connecting?')}.any?{|status| status == true}
  end

  def netflix_connecting?
    netflix_status.eql?("processing")
  end
  def instapaper_connecting?
    instapaper_status.eql?("processing")
  end

  def netflix_connected?
    netflix_status.eql?("processed")
  end
  def instapaper_connected?
    instapaper_status.eql?("processed")
  end

  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
    end 
    update_attributes(params) 
    clean_up_passwords
  end

  private
  def valid_signup_codes
    ['humbly']
  end

  def check_signup_code
    if valid_signup_codes.include?(self.signup_code)
      return true
    else
      errors.add(:base, 'invalid signup code')
      return false
    end
  end

  def process_netflix_queue(queue = false)
    if Rails.env.production? or queue
      Resque.enqueue(NetflixQueueProcessor, self.id)
      self.netflix_status = 'processing'
    else
      NetflixQueueProcessor.perform(id)
      self.netflix_status = 'processed'
    end
  end
  def process_instapaper_queue(queue = false)
    if Rails.env.production? or queue
      Resque.enqueue(InstapaperQueueProcessor, self.id)
      self.instapaper_status = 'processing'
    else
      InstapaperQueueProcessor.perform(id)
      self.instapaper_status = 'processed'
    end
  end
end
