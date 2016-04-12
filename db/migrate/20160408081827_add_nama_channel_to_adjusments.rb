class AddNamaChannelToAdjusments < ActiveRecord::Migration
  def change
    add_column :adjusments, :nama_channel, :string
  end
end
