# == Schema Information
#
# Table name: context_options
#
#  id         :integer          not null, primary key
#  context_id :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContextOption < ActiveRecord::Base
  belongs_to :context

  attr_accessible :context_id, :name
end
