class AddAddressNumberToChannelCustomers < ActiveRecord::Migration
  def change
    add_column :channel_customers, :address_number, :integer, :default => nil
  end
end
