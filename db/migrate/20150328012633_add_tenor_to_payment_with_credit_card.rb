class AddTenorToPaymentWithCreditCard < ActiveRecord::Migration
  def change
    add_column :payment_with_credit_cards, :tenor, :string
    add_column :payment_with_credit_cards, :mid, :string
  end
end
