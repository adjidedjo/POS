class RemoveColumnFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :asal_so
    remove_column :sales, :payment_with_card
    remove_column :sales, :nama_kartu
    remove_column :sales, :no_merchant
    remove_column :sales, :atas_nama
    remove_column :sales, :venue_id
  end
end
