class RenameColumnBankAccountToAcquittances < ActiveRecord::Migration
  def change
    rename_column :acquittances, :bank_account, :bank_account_id
  end
end
