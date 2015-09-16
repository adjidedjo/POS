class RenameColumnNoBuBuktiReturnToStoreSalesAndStockHistories < ActiveRecord::Migration
  def up
    rename_column :store_sales_and_stock_histories, :no_bu_bukti_return, :no_bukti_return
  end

  def down
    rename_column :store_sales_and_stock_histories, :no_bukti_return, :no_bu_bukti_return
  end
end
