class CreateIdeaWeights < ActiveRecord::Migration
  def change
    create_table :idea_weights do |t|
      t.integer :idea_id
      t.integer :context_id
      t.integer :context_option_id
      t.integer :weight

      t.timestamps
    end
  end
end
