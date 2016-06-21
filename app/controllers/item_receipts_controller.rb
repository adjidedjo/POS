class ItemReceiptsController < ApplicationController
  before_action :get_store_id

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
    @receipt = ExhibitionStockItem.where(channel_customer_id: current_user.channel_customer.id,
      checked_in: true).where("created_at >= ?", Date.today)
  end

  def process_receipt
    get_code = JdeItemAvailability.find_serial(params[:serial])
    if get_code.present?
      get_item = JdeItemAvailability.find_item_master(get_code.first.liitm.to_i)
      get_desc1 = JdeItemMaster.find_item_desc1(get_item)
      get_desc2 = JdeItemMaster.find_item_desc2(get_item)
      if ExhibitionStockItem.where(serial: params[:serial]).empty?
        ExhibitionStockItem.create(kode_barang: get_item.strip,
          channel_customer_id: current_user.channel_customer.id, checked_in: true, serial: params[:serial], nama: (get_desc1.strip+" "+get_desc2.strip),
          jumlah: 1, stok_awal: 1, no_sj: 0, stocking_type: "CS")
        StoreSalesAndStockHistory.create(channel_customer_id: current_user.channel_customer.id,
          kode_barang: get_item.strip, nama: (get_desc1.strip+" "+get_desc2.strip), tanggal: Time.now, qty_in: 1, qty_out: 0,
          keterangan: "R", serial: params[:serial])
        redirect_to  item_receipts_receipt_path, notice: "Barang yang di SCAN telah Masuk Menjadi STOK"
      else
        redirect_to  item_receipts_receipt_path, :flash => { :error => "BARANG SUDAH ADA" }
      end
    else
      redirect_to  item_receipts_receipt_path, :flash => { :error => "SERIAL TIDAK DIKENAL" }
    end
  end

  def receipt_by_serial
    @receipt_by_serial = ExhibitionStockItem.where(channel_customer_id: current_user.channel_customer,
      checked_in: false, kode_barang: params[:kode_barang]).all
  end

  def process_receipt_by_serial
    #    params[:receipt_ids].each do |key, value|
    #      @item_selected = value["kode_barang"]
    #      item = ExhibitionStockItem.find_by_kode_barang_and_serial_and_store_id(value["kode_barang"], value["serial"], @user_store)
    #      item.update_attributes!(checked_in: true, checked_in_by: current_user.id) if item.present?
    #    end
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
    redirect_to  item_receipts_receipt_by_serial_path(kode_barang: @item_selected)
  end

  private

  def get_store_id
    @user_store = current_user.store.present? ? current_user.store.id : 0
    @user_showroom = current_user.showroom.present? ? current_user.showroom.id : 0
  end
end
