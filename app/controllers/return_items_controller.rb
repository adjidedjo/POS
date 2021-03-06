class ReturnItemsController < ApplicationController
  before_action :get_store_id

  def return
    @return = ExhibitionStockItem.where("channel_customer_id = ? and checked_in = ? and checked_out = ? and jumlah > ?",
      current_user.channel_customer, true, false, 0).group(:kode_barang)
  end

  def process_return
    params[:return].each do |key, value|
      items = ExhibitionStockItem.where("kode_barang = ? and channel_customer_id = ? and checked_in = ?
and checked_out = ? and jumlah > 0", value["kode_barang"], current_user.channel_customer, true, false)
      if items.sum(:jumlah) == value["jumlah"].to_i
        items.each do |item|
          item.update_attributes!(checked_out: true, checked_out_by: current_user.id)
          StoreSalesAndStockHistory.create(channel_customer_id: current_user.channel_customer.id,
            kode_barang: item.kode_barang, nama: item.nama, tanggal: Time.now, qty_out: item.jumlah, keterangan: "B",
            no_sj: item.no_sj, serial: item.serial)
        end
      end
    end
    redirect_to return_items_return_path, notice: 'Jika barang sudah di cek, tetapi masih tampil. Silahkan scan sesuai serial dengan mengklik kode barang'
  end

  def return_by_serial
    @return_by_serial = ExhibitionStockItem.where("channel_customer_id = ? and checked_in = ? and checked_out = ?
and kode_barang = ? and jumlah > ?", current_user.channel_customer, true, false, params[:kode_barang], 0).all
  end

  def process_return_by_serial
    #    params[:return].each do |key, value|
    #      @item_selected = value["kode_barang"]
    #      item = ExhibitionStockItem.find_by_kode_barang_and_serial_and_store_id(value["kode_barang"], value["serial"], @user_store)
    #      item.update_attributes!(checked_out: true, checked_out_by: current_user.id) if item.present?
    #    end
    rc = ExhibitionStockItem.find(params[:return_ids])
    rc.each do |a|
      a.update_attributes!(checked_out: true, checked_out_by: current_user.id)
      StoreSalesAndStockHistory.create(channel_customer_id: current_user.channel_customer.id,
        kode_barang: a.kode_barang, nama: a.nama, tanggal: Time.now, qty_out: a.jumlah, keterangan: "B",
        no_sj: a.no_sj, serial: a.serial)
      @item_selected = a.kode_barang
    end
    redirect_to  return_items_return_by_serial_path(kode_barang: @item_selected)
  end

  private

  def get_store_id
    @user_store = current_user.store.present? ? current_user.store.id : 0
    @user_showroom = current_user.showroom.present? ? current_user.showroom.id : 0
  end
end