class CreateSuggestionTracks < ActiveRecord::Migration
  def change
    create_table :suggestion_tracks do |t|
      t.integer :user_id
      t.integer :content_item_id
      t.timestamp :on
      t.string :via
      t.string :status
      t.boolean :opened
      t.timestamp :opened_on

      t.timestamps
    end
  end
end
