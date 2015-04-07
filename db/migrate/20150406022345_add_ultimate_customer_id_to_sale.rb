class AddUltimateCustomerIdToSale < ActiveRecord::Migration
  def up
    add_column :sales, :ultimate_customer_id, :integer
  end

  def down
    remove_column :sales, :ultimate_customer_id, :integer
  end
end
