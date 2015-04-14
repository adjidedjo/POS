class AddAmountToAcquittances < ActiveRecord::Migration
  def change
    add_column :acquittances, :cash_amount, :decimal
    add_column :acquittances, :transfer_amount, :decimal
    add_column :acquittances, :bank_account, :string
  end
end
