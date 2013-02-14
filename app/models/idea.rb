# == Schema Information
#
# Table name: ideas
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  context_bits :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Idea < ActiveRecord::Base
  has_many :idea_weights

  attr_accessible :name, :context_bits

end
