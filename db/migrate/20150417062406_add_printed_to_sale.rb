class AddPrintedToSale < ActiveRecord::Migration
  def change
    add_column :sales, :printed, :boolean, :default => 0
  end
end
