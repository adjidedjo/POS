class ItemReceiptsController < ApplicationController
  before_action :get_store_id

  def receipt
    @receipt = ExhibitionStockItem.where(store_id: @user_store, checked_in: false).group(:kode_barang)
  end

  def process_receipt
    params[:receipt].each do |key, value|
      items = ExhibitionStockItem.where(kode_barang: value["kode_barang"], store_id: @user_store, checked_in: false)
      if items.sum(:jumlah) == value["jumlah"].to_i
        items.each do |item|
          item.update_attributes!(checked_in: true, checked_in_by: current_user.id)
          cek_kode = StoreSalesAndStockHistory.find_by_kode_barang_and_no_sj_and_keterangan(item.kode_barang, item.no_sj,'R')
          if cek_kode.nil?
            StoreSalesAndStockHistory.create(exhibition_id: item.store_id, kode_barang: item.kode_barang, nama: item.nama, tanggal: item.created_at.to_date, qty_in: item.jumlah, qty_out: 0, keterangan: "R", no_sj: item.no_sj)
          else
            cek_kode.update_attributes(qty_in: (item.jumlah + cek_kode.qty_in))
          end
        end
      end
    end
    redirect_to  item_receipts_receipt_path, notice: 'Jika barang sudah di cek, tetapi masih tampil. Silahkan scan sesuai serial dengan mengklik kode barang'
  end

  def receipt_by_serial
    @receipt_by_serial = ExhibitionStockItem.where(store_id: @user_store, checked_in: false, kode_barang: params[:kode_barang]).all
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
      cek_kode = StoreSalesAndStockHistory.find_by_kode_barang_and_no_sj_and_keterangan(a.kode_barang, a.no_sj,'R')
      if cek_kode.nil?
        StoreSalesAndStockHistory.create(exhibition_id: a.store_id, kode_barang: a.kode_barang, nama: a.nama, tanggal: a.created_at.to_date, qty_in: a.jumlah, qty_out: 0, keterangan: "R", no_sj: a.no_sj)
      else
        cek_kode.update_attributes(qty_in: (a.jumlah + cek_kode.qty_in))
      end
      @item_selected = a.kode_barang
    end
    redirect_to  item_receipts_receipt_by_serial_path(kode_barang: @item_selected)
  end

  private

  def get_store_id
    @user_store = current_user.store.id
  end
end
