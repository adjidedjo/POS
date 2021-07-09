class CreateAcquittanceWithCreditCards < ActiveRecord::Migration
  def change
    create_table :acquittance_with_credit_cards do |t|
      t.integer :acquittance_id
      t.string :no_merchant
      t.string :no_kartu_kredit
      t.string :tenor
      t.string :mid
      t.string :nama_kartu
      t.string :atas_nama
      t.decimal :jumlah, :default => 0

      t.timestamps null: false
    end
  end
end
