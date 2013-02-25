class AddLastKnownsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_location, :string
    add_column :users, :last_latitude, :string
    add_column :users, :last_longitude, :string
  end
end
