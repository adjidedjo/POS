class AddUserIdToSpgAndMerchant < ActiveRecord::Migration
  def up
    add_column :merchants, :user_id, :integer
    add_column :sales_promotions, :user_id, :integer
    remove_column :merchants, :store_id, :integer
    remove_column :merchants, :showroom_id, :integer
    remove_column :sales_promotions, :store_id, :integer
    remove_column :sales_promotions, :showroom_id, :integer
  end

  def down
    remove_column :merchants, :user_id, :integer
    remove_column :sales_promotions, :user_id, :integer
    add_column :merchants, :store_id, :integer
    add_column :merchants, :showroom_id, :integer
    add_column :sales_promotions, :store_id, :integer
    add_column :sales_promotions, :showroom_id, :integer
  end
end
