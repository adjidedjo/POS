class TransferItem < ActiveRecord::Base
  validates :nbrg, :jml, :tsh, presence: true

  before_create do
    channel = ChannelCustomer.find_by_id(self.ash).id
    self.tsh = ChannelCustomer.find_by_nama(self.tsh).id
    self.ash = channel
    last_order = TransferItem.where(ash: self.ash).last
    no_ret = if last_order.present? && last_order.tfnmr.present?
      if last_order.tfnmr[5..6] == Date.today.strftime('%m')
        no = last_order.tfnmr[-4,4]
        no.succ    
      else
        '0001'
      end
    else
      '0001'
    end
    self.tfnmr = (sprintf '%03d', channel) + (Date.today.strftime('%m') + Date.today.strftime('%y')) + no_ret
  end

  after_create do
    reset_recent_stock
    ChannelCustomer.find(self.ash).warehouse_recipients.each do |rc|
      UserMailer.transfer_items(self, rc.warehouse_admin.email).deliver_now
    end
  end

  def reset_recent_stock
    if self.sn.present?
      recent_stock = ExhibitionStockItem.where(channel_customer_id: self.ash, serial: self.sn).first
      recent_stock.update_attributes!(channel_customer_id: self.tsh, jumlah: recent_stock.jumlah, checked_in: false)
      creating_item_mutation(self, recent_stock.no_sj)
    else
      recent_stock = ExhibitionStockItem.where(channel_customer_id: self.ash, kode_barang: self.brg).first
      recent_stock.update_attributes!(jumlah: (recent_stock.jumlah - self.jml))
      ExhibitionStockItem.create(recent_stock.attributes.merge({id: nil, channel_customer_id: self.tsh, jumlah: self.jml, checked_in: false,
            created_at: Time.now, updated_at: Time.now, stok_awal: self.jml}))
      creating_item_mutation(self, recent_stock.no_sj)
    end
  end

  def creating_item_mutation(tfi, no_sj)
    StoreSalesAndStockHistory.create(channel_customer_id: tfi.ash,
      kode_barang: tfi.brg, nama: tfi.nbrg, tanggal: Time.now, qty_out: tfi.jml, keterangan: "B",
      no_sj: no_sj, serial: tfi.sn)
  end
end