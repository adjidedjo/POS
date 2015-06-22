class Accounting::StocksController < ApplicationController
  def view_penjualan
    @sale_items = []
    @channel_customer = ChannelCustomer.find(params[:cc_id])
    @sales = Sale.all.where(cancel_order: false, channel_customer_id: @channel_customer.id)
    @sales.where(channel_customer_id: params[:cc_id], cancel_order: false).each do |sale|
      SaleItem.where(sale_id: sale.id).each do |sale_item|
        @sale_items << sale_item
      end
    end

    respond_to do |format|
      format.html
      format.xls
    end
  end

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
    @report_stock_in = StoreSalesAndStockHistory.where(channel_customer_id: params[:cc_id]).where("qty_in > ?", 0).group([:kode_barang, :no_sj])
    @report_stock_out = StoreSalesAndStockHistory.where(channel_customer_id: params[:cc_id], keterangan: "S")
    @report_stock_return = StoreSalesAndStockHistory.where(channel_customer_id: params[:cc_id], keterangan: "B")

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def mutasi_stock
    @channel_customer = []
    channel = current_user.branch.sales_counters
    if channel.present?
      current_user.branch.sales_counters.group(:branch_id).each do |sc|
        sc.recipients.group(:channel_customer_id, :sales_counter_id).each do |scr|
          @channel_customer << scr.channel_customer
        end
      end
    end
  end
end
