class RemoveColumnOnSale < ActiveRecord::Migration
  def change
    remove_column :sales, :no_kartu_debit
    remove_column :sales, :nama_kartu_debit
  end
end
