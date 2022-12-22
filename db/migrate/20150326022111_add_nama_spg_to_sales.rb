class AddNamaSpgToSales < ActiveRecord::Migration
  def change
    add_column :sales, :nama_spg, :string
  end
end
