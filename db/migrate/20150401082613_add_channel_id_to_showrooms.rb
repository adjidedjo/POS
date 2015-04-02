class AddChannelIdToShowrooms < ActiveRecord::Migration
  def change
    add_column :showrooms, :channel_id, :integer
  end
end
