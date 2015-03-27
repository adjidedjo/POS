class ChangeTanggalInStoreSalesAndStockHistories < ActiveRecord::Migration
  def change
    change_column :store_sales_and_stock_histories, :tanggal, :datetime
  end
end
