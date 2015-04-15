class ChangeColumnNoKartuDebitOnPaymentWithDebit < ActiveRecord::Migration
  def change
    rename_column :payment_with_debit_cards, :no_kartu, :no_kartu_debit
  end
end