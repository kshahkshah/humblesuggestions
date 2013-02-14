class CreateContextOptions < ActiveRecord::Migration
  def change
    create_table :context_options do |t|
      t.integer :context_id
      t.string :name

      t.timestamps
    end
  end
end
