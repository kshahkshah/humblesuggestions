class AddServiceStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :netflix_status, :string
    add_column :users, :instapaper_status, :string
  end
end
