class AddSerialToStoreSalesAndStockHistories < ActiveRecord::Migration
  def change
    add_column :store_sales_and_stock_histories, :serial, :string
  end
end
