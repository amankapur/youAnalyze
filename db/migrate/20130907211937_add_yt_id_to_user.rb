class AddYtIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :yt_id, :string
  end
end
