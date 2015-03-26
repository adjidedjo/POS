class RenameNamaSpgInSales < ActiveRecord::Migration
  def change
    rename_column :sales, :nama_spg, :product_consultant
  end
end
