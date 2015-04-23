class Accounting::StocksController < ApplicationController
  def view_selisih_stock
    @retur = ExhibitionStockItem.where(channel_customer_id: params[:cc_id]).group(:kode_barang, :no_sj)

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def view_selisih_intransit
    @intransit = ExhibitionStockItem.where(channel_customer_id: params[:cc_id]).group(:kode_barang, :no_sj)

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def view_stock
    @report_stock_in = StoreSalesAndStockHistory.where(channel_customer_id: params[:cc_id]).where("qty_in > ?", 0)
    @report_stock_out = StoreSalesAndStockHistory.where(channel_customer_id: params[:cc_id], keterangan: "S").where("qty_out > ?", 0)
    @report_stock_return = StoreSalesAndStockHistory.where(channel_customer_id: params[:cc_id], keterangan: "B").where("qty_out > ?", 0)

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def mutasi_stock
    @channel_customer = ChannelCustomer.all
  end
end
