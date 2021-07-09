class AddBankAccountIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :bank_account_id, :integer
    add_column :sales, :jumlah_transfer, :decimal
  end
end
