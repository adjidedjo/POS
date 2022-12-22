class AddNoKartuToPaymentWithDebitCards < ActiveRecord::Migration
  def change
    add_column :payment_with_debit_cards, :no_kartu, :string
  end
end
