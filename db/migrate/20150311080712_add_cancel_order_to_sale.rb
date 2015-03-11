class AddCancelOrderToSale < ActiveRecord::Migration
  def change
    add_column :sales, :cancel_order, :boolean, :default => 0
  end
end
