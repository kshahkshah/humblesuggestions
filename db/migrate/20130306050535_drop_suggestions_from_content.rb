class DropSuggestionsFromContent < ActiveRecord::Migration
  def change
    remove_column :content_suggestions, :suggested_on
    remove_column :content_suggestions, :suggested_via
    execute("ALTER TABLE content_suggestions RENAME TO content_items")
  end
end
