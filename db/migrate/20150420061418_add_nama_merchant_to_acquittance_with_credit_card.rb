class AddNamaMerchantToAcquittanceWithCreditCard < ActiveRecord::Migration
  def change
    add_column :acquittance_with_credit_cards, :nama_merchant, :string
  end
end
