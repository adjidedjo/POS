class ChangeColumnAcquittanceAmount < ActiveRecord::Migration
  def change
    change_column :acquittances, :cash_amount, :decimal, :default => 0
    change_column :acquittances, :transfer_amount, :decimal, :default => 0
  end
end
