class AddExNoSjToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :ex_no_sj, :string
  end
end
