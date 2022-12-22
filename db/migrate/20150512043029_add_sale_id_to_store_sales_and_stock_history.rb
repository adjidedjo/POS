class AddSaleIdToStoreSalesAndStockHistory < ActiveRecord::Migration
  def change
    add_column :store_sales_and_stock_histories, :sale_id, :integer
  end
end
