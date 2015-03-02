class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.integer :channel_id
      t.string :nama
      t.string :kota
      t.date :from_period
      t.date :to_period

      t.timestamps null: false
    end
  end
end
