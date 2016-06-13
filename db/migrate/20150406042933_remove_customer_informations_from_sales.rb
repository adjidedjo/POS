class RemoveCustomerInformationsFromSales < ActiveRecord::Migration
  def up
    remove_column :sales, :customer
    remove_column :sales, :email
    remove_column :sales, :phone_number
    remove_column :sales, :hp1
    remove_column :sales, :hp2
    remove_column :sales, :alamat_kirim
    remove_column :sales, :kota
  end

  def down
    add_column :sales, :customer, :string
    add_column :sales, :email, :string
    add_column :sales, :phone_number, :string
    add_column :sales, :hp1, :string
    add_column :sales, :hp2, :string
    add_column :sales, :alamat_kirim, :text
    add_column :sales, :kota, :string
  end
end
