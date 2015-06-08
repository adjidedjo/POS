class AddChannelCustomerIdToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :channel_customer_id, :integer
  end
end
