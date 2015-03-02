class AddTipePembayaranToSale < ActiveRecord::Migration
  def change
    add_column :sales, :tipe_pembayaran, :string
    add_column :sales, :nama_kartu, :string
    add_column :sales, :no_kartu, :string
    add_column :sales, :no_merchant, :string
    add_column :sales, :atas_nama, :string
  end
end
