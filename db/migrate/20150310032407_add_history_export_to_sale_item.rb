class AddHistoryExportToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :exported_at, :datetime
    add_column :sale_items, :exported_by, :integer, :default => 0
    add_column :sale_items, :exported, :boolean, :default => false
  end
end
