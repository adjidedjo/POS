class CreateUnidentifiedSerials < ActiveRecord::Migration
  def change
    create_table :unidentified_serials do |t|
      t.string :serial

      t.timestamps null: false
    end
  end
end
