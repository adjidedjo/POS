class AddNamaMerchantToPaymentWithCreditCard < ActiveRecord::Migration
  def change
    add_column :payment_with_credit_cards, :nama_merchant, :string
  end
end
