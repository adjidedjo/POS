class Accounting::StocksController < ApplicationController
  before_action :set_controller, only: [:show, :mutasi_stock]

  def available_stock
    @stock = ExhibitionStockItem.where(channel_customer_id: params[:cc_id]).where.not(jumlah: 0).group(:kode_barang)
    @channel = ChannelCustomer.find(params[:cc_id])

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def view_penjualan
    @channel_customer = ChannelCustomer.find(params[:cc_id])
    @sale_items = []
    if params[:search].present?
      dari_tanggal =  params[:search][:dari_tanggal]
      sampai_tangggal =  params[:search][:sampai_tanggal]
      cc_id =  params[:cc_id]
      @sales = Sale.search_for_acc(dari_tanggal.to_date, sampai_tangggal.to_date, cc_id.to_i).order("created_at DESC")
      @sales.where(channel_customer_id: params[:cc_id], cancel_order: false).each do |sale|
        SaleItem.where(sale_id: sale.id).each do |sale_item|
          @sale_items << sale_item
        end
      end
    else
      @sale_items = []
      @sales = Sale.all.where("cancel_order = ? and channel_customer_id = ? and date(created_at) >= ?",false,@channel_customer.id, 2.month.ago).order("created_at DESC")
      @sales.where(channel_customer_id: params[:cc_id], cancel_order: false).each do |sale|
        SaleItem.where(sale_id: sale.id).each do |sale_item|
          @sale_items << sale_item
        end
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
    channel = current_user.branch.present? ? current_user.branch.sales_counters : []
    if channel.present?
      current_user.branch.sales_counters.group(:branch_id).each do |sc|
        sc.recipients.group(:channel_customer_id, :sales_counter_id).each do |scr|
          @channel_customer << scr.channel_customer
        end
      end
    else
      ChannelCustomer.all.each do |cc|
        @channel_customer << cc
      end
    end
  end

  private
  def set_controller
    @controller = current_user.role == 'controller'
  end
end
