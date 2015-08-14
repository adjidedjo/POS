class AddNettoSerenityToSales < ActiveRecord::Migration
  def change
    add_column :sales, :netto_serenity, :float
    add_column :sales, :netto_royal, :float
    add_column :sales, :netto_tech, :float
  end
end
