class AddNettoAndPembayaranToSale < ActiveRecord::Migration
  def change
    add_column :sales, :netto, :decimal
    add_column :sales, :pembayaran, :decimal
  end
end
