class ChangeColumnBankAccountId < ActiveRecord::Migration
  def up
    change_column :acquittances, :bank_account_id, :integer
  end
  def down
    change_column :acquittances, :bank_account_id, :string
  end
end
