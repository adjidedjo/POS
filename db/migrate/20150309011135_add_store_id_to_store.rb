class AddStoreIdToStore < ActiveRecord::Migration
  def change
    add_column :stores, :store_id, :integer
  end
end
