class AddAllItemsExportedToSale < ActiveRecord::Migration
  def change
    add_column :sales, :all_items_exported, :boolean, :default => 0
  end
end
