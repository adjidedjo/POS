class AddNamaSpgToSale < ActiveRecord::Migration
  def change
    add_column :sales, :nama_sp, :string
    remove_column :sales, :supervisor_exhibition_id
    remove_column :sales, :sales_promotion_id
  end
end
