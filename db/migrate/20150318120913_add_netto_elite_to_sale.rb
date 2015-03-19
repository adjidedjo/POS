class AddNettoEliteToSale < ActiveRecord::Migration
  def change
    add_column :sales, :netto_elite, :decimal
    add_column :sales, :netto_lady, :decimal
  end
end
