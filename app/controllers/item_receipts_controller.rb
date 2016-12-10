class ItemReceiptsController < ApplicationController
  before_action :get_store_id
  
  def reject_by_serial
    rc = ExhibitionStockItem.find(params[:receipt_ids])
    rc.each do |a|
      a.update_attributes!(rejected: true)
      @item_selected = a.kode_barang
    end
  end
  
  def reject
    params[:receipt].each do |key, value|
      items = ExhibitionStockItem.where(kode_barang: value["kode_barang"],
        channel_customer_id: current_user.channel_customer, checked_in: false)
        items.each do |item|
          item.update_attributes!(rejected: true)
      end
    end
  end

  def check_item_value
    check_stok = ExhibitionStockItem.where(kode_barang: params[:kodebrg], no_sj: params[:nosj], channel_customer_id: params[:cc], checked_in: false).sum(:jumlah)
    @element_id = params[:element_id]
    if check_stok != params[:val].to_i
      raise params[:val]
    end

    respond_to do |format|
      format.js
    end
  end

  def receipt
    @receipt = ExhibitionStockItem.where(channel_customer_id: current_user.channel_customer, 
    checked_in: false, rejected: false).group(:kode_barang)
  end

  def process_receipt
    if params[:reject]
      reject
    else
      params[:receipt].each do |key, value|
        items = ExhibitionStockItem.where(kode_barang: value["kode_barang"],
          channel_customer_id: current_user.channel_customer, checked_in: false)
        if items.sum(:jumlah) == value["jumlah"].to_i
          items.each do |item|
            item.update_attributes!(checked_in: true, checked_in_by: current_user.id)
            cek_kode = StoreSalesAndStockHistory.find_by_kode_barang_and_no_sj_and_keterangan_and_channel_customer_id(
              item.kode_barang, item.no_sj,'R', current_user.channel_customer)
            if cek_kode.nil?
              StoreSalesAndStockHistory.create(channel_customer_id: current_user.channel_customer.id,
                kode_barang: item.kode_barang, nama: item.nama, tanggal: Time.now, qty_in: item.jumlah, qty_out: 0,
                keterangan: "R", no_sj: item.no_sj, serial: item.serial)
            else
              cek_kode.update_attributes(qty_in: (item.jumlah + cek_kode.qty_in))
            end
          end
        end
      end
    end
    redirect_to  item_receipts_receipt_path, notice: 'Jika barang sudah di cek, tetapi masih tampil.
Silahkan scan sesuai serial dengan mengklik kode barang'
  end

  def receipt_by_serial
    @receipt_by_serial = ExhibitionStockItem.where(channel_customer_id: current_user.channel_customer, 
    checked_in: false, rejected: false, kode_barang: params[:kode_barang]).all
  end

  def process_receipt_by_serial
    #    params[:receipt_ids].each do |key, value|
    #      @item_selected = value["kode_barang"]
    #      item = ExhibitionStockItem.find_by_kode_barang_and_serial_and_store_id(value["kode_barang"], value["serial"], @user_store)
    #      item.update_attributes!(checked_in: true, checked_in_by: current_user.id) if item.present?
    #    end
    if params[:reject]
      reject_by_serial
    else
      rc = ExhibitionStockItem.find(params[:receipt_ids])
      rc.each do |a|
        a.update_attributes!(checked_in: true, checked_in_by: current_user.id)
        cek_kode = StoreSalesAndStockHistory.find_by_kode_barang_and_no_sj_and_keterangan_and_channel_customer_id_and_serial(
          a.kode_barang, a.no_sj,'R', current_user.channel_customer, a.serial)
        if cek_kode.nil?
          StoreSalesAndStockHistory.create(channel_customer_id: current_user.channel_customer.id,
            kode_barang: a.kode_barang, nama: a.nama, tanggal: Time.now, qty_in: a.jumlah, qty_out: 0,
            keterangan: "R", no_sj: a.no_sj, serial: a.serial)
        else
          cek_kode.update_attributes(qty_in: (a.jumlah + cek_kode.qty_in))
        end
        @item_selected = a.kode_barang
      end
    end
     redirect_to  item_receipts_receipt_by_serial_path(kode_barang: @item_selected)
  end

  private

  def get_store_id
    @user_store = current_user.store.present? ? current_user.store.id : 0
    @user_showroom = current_user.showroom.present? ? current_user.showroom.id : 0
  end
end
