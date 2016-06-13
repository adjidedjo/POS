class AddNoOrderToSales < ActiveRecord::Migration
  def change
    add_column :sales, :no_order, :string
  end
end
