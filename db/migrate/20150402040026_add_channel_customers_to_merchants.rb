class AddChannelCustomersToMerchants < ActiveRecord::Migration
  def up
    add_column :merchants, :channel_customer_id, :integer
    add_column :sales_promotions, :channel_customer_id, :integer
    add_column :supervisor_exhibitions, :channel_customer_id, :integer
    add_column :sales, :channel_customer_id, :integer
    add_column :exhibition_stock_items, :channel_customer_id, :integer
    add_column :store_sales_and_stock_histories, :channel_customer_id, :integer
    remove_column :merchants, :user_id, :integer
    remove_column :sales_promotions, :user_id, :integer
  end

  def down
    remove_column :merchants, :channel_customer_id, :integer
    remove_column :sales_promotions, :channel_customer_id, :integer
    remove_column :supervisor_exhibitions, :channel_customer_id, :integer
    remove_column :sales, :channel_customer_id, :integer
    remove_column :exhibition_stock_items, :channel_customer_id, :integer
    remove_column :store_sales_and_stock_histories, :channel_customer_id, :integer
    add_column :merchants, :user_id, :integer
    add_column :sales_promotions, :user_id, :integer
  end
end
