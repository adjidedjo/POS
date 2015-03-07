class AddVoucherToSale < ActiveRecord::Migration
  def change
    add_column :sales, :voucher, :decimal
    add_column :sales, :nama_kartu_debit, :string
    add_column :sales, :no_kartu_debit, :string
  end
end
