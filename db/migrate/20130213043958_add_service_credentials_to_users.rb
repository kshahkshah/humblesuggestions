class AddServiceCredentialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :netflix_user_id, :string
    add_column :users, :netflix_token, :string
    add_column :users, :netflix_secret, :string
    add_column :users, :instapaper_user_id, :string
    add_column :users, :instapaper_token, :string
    add_column :users, :instapaper_secret, :string
  end
end
