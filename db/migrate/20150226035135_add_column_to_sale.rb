class AddColumnToSale < ActiveRecord::Migration
  def change
    add_column :sales, :channel_id, :integer
    add_column :sales, :store_id, :integer
  end
end
