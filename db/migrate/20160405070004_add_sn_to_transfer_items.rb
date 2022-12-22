class AddSnToTransferItems < ActiveRecord::Migration
  def change
    add_column :transfer_items, :sn, :string
  end
end
