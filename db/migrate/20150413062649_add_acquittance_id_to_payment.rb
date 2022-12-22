class AddAcquittanceIdToPayment < ActiveRecord::Migration
  def change
    add_column :payment_with_debit_cards, :acquittance_id, :integer
    add_column :payment_with_credit_cards, :acquittance_id_, :integer
  end
end
