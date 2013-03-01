# == Schema Information
#
# Table name: content_suggestions
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  content_type     :string(255)
#  content_provider :string(255)
#  content_id       :string(255)
#  title            :string(255)
#  description      :text
#  image            :string(255)
#  rating           :string(255)
#  position         :string(255)
#  time_added       :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  suggested_on     :datetime
#  suggested_via    :string(255)
#

class ContentSuggestion < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id, :content_id, :content_provider, :content_type, :description, :image, :position, :rating, :time_added, :title

  def content_link
    if content_provider.eql?('netflix')
      movieid = content_id.split('/').last
      "http://movies.netflix.com/WiPlayer?movieid=#{movieid}"
    elsif content_provider.eql?('instapaper')
      'instapaper.com'
    else
      nil
    end
  end

end
