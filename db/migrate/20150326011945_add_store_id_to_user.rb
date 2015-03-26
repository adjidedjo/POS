class AddStoreIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :store_id, :integer, :default => 0
  end
end
