class RenameColumnJumlahTransferOnSales < ActiveRecord::Migration
  def change
    change_column :sales, :jumlah_transfer, :decimal, :default => 0
  end
end
