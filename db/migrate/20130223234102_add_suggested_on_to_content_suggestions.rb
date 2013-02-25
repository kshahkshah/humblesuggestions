class AddSuggestedOnToContentSuggestions < ActiveRecord::Migration
  def change
    add_column :content_suggestions, :suggested_on, :datetime
  end
end
