class AddDariTanggalToSearchSales < ActiveRecord::Migration
  def change
    add_column :search_sales, :dari_tanggal, :date
    add_column :search_sales, :sampai_tanggal, :date
  end
end
