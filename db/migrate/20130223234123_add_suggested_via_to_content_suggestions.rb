class AddSuggestedViaToContentSuggestions < ActiveRecord::Migration
  def change
    add_column :content_suggestions, :suggested_via, :string
  end
end
