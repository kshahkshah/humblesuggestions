class ContentSuggestion < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id, :content_id, :content_provider, :content_type, :description, :image, :position, :rating, :time_added, :title
end
