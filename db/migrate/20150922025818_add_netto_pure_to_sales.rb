class AddNettoPureToSales < ActiveRecord::Migration
  def change
    add_column :sales, :netto_pure, :float, :default => 0
  end
end
