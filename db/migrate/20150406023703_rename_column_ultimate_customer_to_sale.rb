class RenameColumnUltimateCustomerToSale < ActiveRecord::Migration
  def change
    rename_column :sales, :ultimate_customer_id, :pos_ultimate_customer_id
  end
end
