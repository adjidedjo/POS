class ChangeColumns < ActiveRecord::Migration
  def change
    change_column :sales, :netto_elite, :decimal, :default => 0
    change_column :sales, :netto_lady, :decimal, :default => 0
    change_column :sales, :sisa, :decimal, :default => 0
    change_column :sales, :voucher, :decimal, :default => 0
    change_column :sales, :pembayaran, :decimal, :default => 0
    change_column :sales, :netto, :decimal, :default => 0
    change_column :sale_items, :jumlah, :integer, :default => 0
    remove_column :sale_items, :no_so
    remove_column :sale_items, :no_ppb
    remove_column :sale_items, :no_faktur
    remove_column :sale_items, :no_sj
    change_column :payment_with_debit_cards, :jumlah, :decimal, :default => 0
    change_column :payment_with_credit_cards, :jumlah, :decimal, :default => 0
  end
end
