class AddPaymentWithCardToSale < ActiveRecord::Migration
  def change
    add_column :sales, :payment_with_card, :decimal
  end
end
