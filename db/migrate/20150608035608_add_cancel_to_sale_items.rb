class AddCancelToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :cancel, :boolean, :default => 0
  end
end
