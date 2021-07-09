class CreateAcquittanceWithDebitCards < ActiveRecord::Migration
  def change
    create_table :acquittance_with_debit_cards do |t|
      t.integer :acquittance_id
      t.string :nama_kartu
      t.string :no_kartu_debit
      t.string :atas_nama
      t.decimal :jumlah, :default => 0

      t.timestamps null: false
    end
  end
end
