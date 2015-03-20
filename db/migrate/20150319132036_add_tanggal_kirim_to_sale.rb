class AddTanggalKirimToSale < ActiveRecord::Migration
  def change
    add_column :sales, :tanggal_kirim, :date
  end
end
