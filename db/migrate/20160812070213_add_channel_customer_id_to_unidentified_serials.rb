class AddChannelCustomerIdToUnidentifiedSerials < ActiveRecord::Migration
  def change
    add_column :unidentified_serials, :channel_customer_id, :integer
  end
end
