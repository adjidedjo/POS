class AddNoSaleToSale < ActiveRecord::Migration
  def change
    add_column :sales, :no_sale, :integer
  end
end
