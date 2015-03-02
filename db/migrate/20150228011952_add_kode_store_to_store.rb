class AddKodeStoreToStore < ActiveRecord::Migration
  def change
    add_column :stores, :kode_customer, :string
  end
end
