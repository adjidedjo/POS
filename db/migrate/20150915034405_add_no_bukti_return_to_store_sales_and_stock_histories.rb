class AddNoBuktiReturnToStoreSalesAndStockHistories < ActiveRecord::Migration
  def change
    add_column :store_sales_and_stock_histories, :no_bu_bukti_return, :string
  end
end
