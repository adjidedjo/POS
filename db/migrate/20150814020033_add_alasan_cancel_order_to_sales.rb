class AddAlasanCancelOrderToSales < ActiveRecord::Migration
  def change
    add_column :sales, :alasan_cancel, :text
  end
end
