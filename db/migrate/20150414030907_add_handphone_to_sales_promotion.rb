class AddHandphoneToSalesPromotion < ActiveRecord::Migration
  def change
    add_column :sales_promotions, :handphone, :string
    add_column :sales_promotions, :handphone1, :string
    add_column :supervisor_exhibitions, :handphone, :string
    add_column :supervisor_exhibitions, :handphone1, :string
  end
end
