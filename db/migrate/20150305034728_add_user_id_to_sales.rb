class AddUserIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :user_id, :integer
    remove_column :users, :user_id
  end
end
