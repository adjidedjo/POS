class AddTampilkanBerdasarkanToSearchSales < ActiveRecord::Migration
  def change
    add_column :search_sales, :tampilkan_berdasarkan, :string
  end
end
