class AddPrintedToSalesStoreSalesAndStockHistories < ActiveRecord::Migration
  def change
    add_column :store_sales_and_stock_histories, :printed, :boolean, :default => 0
  end
end
