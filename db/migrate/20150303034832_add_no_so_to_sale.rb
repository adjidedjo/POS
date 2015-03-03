class AddNoSoToSale < ActiveRecord::Migration
  def change
    add_column :sales, :no_so, :string
  end
end
