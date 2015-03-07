class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :nama
      t.string :no_merchant
      t.integer :store_id

      t.timestamps null: false
    end
  end
end
