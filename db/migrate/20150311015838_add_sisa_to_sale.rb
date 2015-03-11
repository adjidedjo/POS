class AddSisaToSale < ActiveRecord::Migration
  def change
    add_column :sales, :sisa, :decimal
  end
end
