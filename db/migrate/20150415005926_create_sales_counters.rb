class CreateSalesCounters < ActiveRecord::Migration
  def change
    create_table :sales_counters do |t|
      t.string :nama
      t.string :nik
      t.string :email

      t.timestamps null: false
    end
  end
end
