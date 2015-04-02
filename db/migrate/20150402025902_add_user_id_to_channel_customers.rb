class AddUserIdToChannelCustomers < ActiveRecord::Migration
  def change
    add_column :channel_customers, :user_id, :integer
  end
end
