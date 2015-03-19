class CreatePaymentWithDebitCards < ActiveRecord::Migration
  def change
    create_table :payment_with_debit_cards do |t|
      t.string :nama_kartu
      t.string :no_kartu
      t.string :atas_nama
      t.decimal :jumlah
      t.integer :sale_id

      t.timestamps null: false
    end
  end
end
