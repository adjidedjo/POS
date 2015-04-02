class AddShowroomIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :showroom_id, :integer
    change_column :sales, :store_id, :integer
  end
end
