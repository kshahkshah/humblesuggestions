# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
         :rememberable, :trackable, :token_authenticatable

  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true, :if => :email_changed?
  validates_format_of :email, :with => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of :password, :on => :save, :allow_blank => true
  validates_confirmation_of :password, :on => :save, :allow_blank => true
  validates_length_of :password, :within => Devise.password_length, :allow_blank => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def self.find_or_create_from_auth_hash(auth_hash)
    # first check if we have that user via that provider...
    @user = User.where("#{auth_hash.provider}_user_id" => auth_hash.uid).first

    # great we have a user, return it
    return @user if @user

    # what if they are connecting a different service and already have an account?
    # well, do a look up by email first then merge the accounts
    if @user = User.where(email: auth_hash.info.email).first
      # add to this account...
      @user.send("#{auth_hash.provider}_user_id=", auth_hash.uid)
      @user.send("#{auth_hash.provider}_token=", auth_hash.credentials.token)
      @user.send("#{auth_hash.provider}_secret=", auth_hash.credentials.secret)
      @user.save
    end

    # fantastic, return the user...
    return @user if @user

    # snap, still no user, welcome aboard...
    @user = User.new({
      email: auth_hash.info.email,
      name:  auth_hash.info.name
    })

    @user.send("#{auth_hash.provider}_user_id=", auth_hash.uid)
    @user.send("#{auth_hash.provider}_token=", auth_hash.credentials.token)
    @user.send("#{auth_hash.provider}_secret=", auth_hash.credentials.secret)
    @user.save
 
    return @user if @user
  end

  def netflix_connected?
    !self.netflix_user_id.blank?
  end
  def instapaper_connected?
    !self.instapaper_user_id.blank?
  end

  def process_netflix_queue!
    NetflixQueueProcessor.perform(self.id)
  end
  def process_instapaper_queue!
    InstapaperQueueProcessor.perform(self.id)
  end

  def process_netflix_queue
    Resque.enqueue("NetflixQueueProcessor", self.id)
  end
  def process_instapaper_queue
    Resque.enqueue("InstapaperQueueProcessor", self.id)
  end

end
