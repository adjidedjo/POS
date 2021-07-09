class RenameColumnNoKartu < ActiveRecord::Migration
  def change
    rename_column :payment_with_debit_cards, :no_kartu, :no_kartu_debit
    rename_column :payment_with_credit_cards, :no_kartu, :no_kartu_kredit
  end
end
