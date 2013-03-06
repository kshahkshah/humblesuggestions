# == Schema Information
#
# Table name: suggestion_tracks
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  content_item_id :integer
#  on              :datetime
#  via             :string(255)
#  status          :string(255)
#  opened          :boolean
#  opened_on       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class SuggestionTrack < ActiveRecord::Base
  belongs_to :content_item
  belongs_to :user

  attr_accessible :user_id, :content_item_id, :on, :via, :status, :opened, :opened_on

end
