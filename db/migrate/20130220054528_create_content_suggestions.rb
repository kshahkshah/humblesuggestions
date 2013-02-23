class CreateContentSuggestions < ActiveRecord::Migration
  def change
    create_table :content_suggestions do |t|
      t.integer :user_id
      t.string :content_type
      t.string :content_provider
      t.string :content_id
      t.string :title
      t.text :description
      t.string :image
      t.string :rating
      t.string :position
      t.string :time_added

      t.timestamps
    end
  end
end
