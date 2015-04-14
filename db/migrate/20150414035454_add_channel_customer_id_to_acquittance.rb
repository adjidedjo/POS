class AddChannelCustomerIdToAcquittance < ActiveRecord::Migration
  def change
    add_column :acquittances, :channel_customer_id, :integer
  end
end
