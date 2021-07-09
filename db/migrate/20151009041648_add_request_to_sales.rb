class AddRequestToSales < ActiveRecord::Migration
  def change
    add_column :sales, :requested_cancel_order, :boolean, :default => 0
    add_column :sales, :rejected, :boolean, :default => 0
    add_column :sales, :rejected_reason, :string
  end
end
