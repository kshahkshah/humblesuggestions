# == Schema Information
#
# Table name: idea_weights
#
#  id                :integer          not null, primary key
#  idea_id           :integer
#  context_id        :integer
#  context_option_id :integer
#  weight            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class IdeaWeight < ActiveRecord::Base
  belongs_to :idea
  belongs_to :context
  belongs_to :context_option

  attr_accessible :context_id, :context_option_id, :idea_id, :weight
end
