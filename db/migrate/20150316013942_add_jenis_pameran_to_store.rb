class AddJenisPameranToStore < ActiveRecord::Migration
  def change
    add_column :stores, :jenis_pameran, :string
    add_column :stores, :keterangan, :text
  end
end
