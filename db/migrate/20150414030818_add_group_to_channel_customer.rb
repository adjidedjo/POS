class AddGroupToChannelCustomer < ActiveRecord::Migration
  def change
    add_column :channel_customers, :group, :string
  end
end
