class ReturnItemsController < ApplicationController
  before_action :get_store_id

  def return
    @return = ExhibitionStockItem.where(store_id: @user_store, checked_in: true, checked_out: false).group(:kode_barang)
  end

  def process_return
    params[:return].each do |key, value|
      items = ExhibitionStockItem.where(kode_barang: value["kode_barang"], store_id: @user_store)
      if items.sum(:jumlah) == value["jumlah"].to_i
        items.each do |item|
          item.update_attributes!(checked_out: true, checked_out_by: current_user.id)
        end
      end
    end
    redirect_to return_items_return_path, notice: 'Jika barang sudah di cek, tetapi masih tampil. Silahkan scan sesuai serial dengan mengklik kode barang'
  end

  def return_by_serial
    @return_by_serial = ExhibitionStockItem.where(store_id: @user_store, checked_in: true, checked_out: false, kode_barang: params[:kode_barang]).all
  end

  def process_return_by_serial
    params[:return].each do |key, value|
      @item_selected = value["kode_barang"]
      item = ExhibitionStockItem.find_by_kode_barang_and_serial_and_store_id(value["kode_barang"], value["serial"], @user_store)
      item.update_attributes!(checked_out: true, checked_out_by: current_user.id) if item.present?
    end
    redirect_to  return_items_return_by_serial_path(kode_barang: @item_selected)
  end

  private

  def get_store_id
    @user_store = current_user.sales_promotion.store.id
  end
end