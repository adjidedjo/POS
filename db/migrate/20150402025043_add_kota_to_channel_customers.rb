class AddKotaToChannelCustomers < ActiveRecord::Migration
  def change
    add_column :channel_customers, :kota, :string
  end
end
