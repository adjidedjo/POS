class Accounting::StocksController < ApplicationController
  before_action :set_controller, only: [:show, :mutasi_stock]

  def check_saldo_stock
    @receipt = ExhibitionStockItem.where(channel_customer_id: current_user.channel_customer.id,
      checked_in: true).order_by("updated_at DESC")
  end

  def process_receipt
    esi = ExhibitionStockItem.where(channel_customer_id: current_user.channel_customer.id,
      checked_in: false, serial: params[:serial]).first
    if esi.present?
      esi.update_attributes!(checked_in: true)
      redirect_to accounting_stocks_check_saldo_stock_path, notice: "Barang yang di SCAN telah Masuk Menjadi STOK"
    else
      UnidentifiedSerial.create(serial: params[:serial], channel_customer_id: current_user.channel_customer.id)
      redirect_to accounting_stocks_check_saldo_stock_path, :flash => { :error => "SERIAL TIDAK DIKENAL/TIDAK ADA" }
    end
  end

  def available_stock
    @stock = ExhibitionStockItem.select('*, sum(jumlah) as total').where(checked_in: true, checked_out: false,
      channel_customer_id: params[:cc_id]).where.not(jumlah: 0).group([:kode_barang, :serial])
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
      @sales.where(channel_customer_id: params[:cc_id]).each do |sale|
        SaleItem.where(sale_id: sale.id).each do |sale_item|
          @sale_items << sale_item
        end
      end
    else
      @sale_items = []
      @sales = Sale.all.where("channel_customer_id = ? and date(created_at) >= ?", @channel_customer.id, 2.month.ago).order("created_at DESC")
      @sales.where(channel_customer_id: params[:cc_id]).each do |sale|
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
    if params[:search].present?
      dari_tanggal =  params[:search][:dari_tanggal]
      sampai_tanggal =  params[:search][:sampai_tanggal]
      @retur = ExhibitionStockItem.where(channel_customer_id: params[:cc_id]).where("updated_at between ? and ?", dari_tanggal, sampai_tanggal).group(:kode_barang, :no_sj)

      respond_to do |format|
        format.html
        format.xls
      end
    end
  end

  def view_selisih_intransit
    if params[:search].present?
      dari_tanggal =  params[:search][:dari_tanggal]
      sampai_tanggal =  params[:search][:sampai_tanggal]
      @intransit = ExhibitionStockItem.where(channel_customer_id: params[:cc_id]).where("updated_at between ? and ?", dari_tanggal, sampai_tanggal).group(:kode_barang, :no_sj)

      respond_to do |format|
        format.html
        format.xls
      end
    end
  end

  def view_stock
    if params[:search].present?
      dari_tanggal =  params[:search][:dari_tanggal]
      sampai_tanggal =  params[:search][:sampai_tanggal]
      cc_id =  params[:cc_id]
      @report_stock_in = StoreSalesAndStockHistory.where(channel_customer_id: cc_id, keterangan: "R").where("updated_at between ? and ?", dari_tanggal, sampai_tanggal)
      @report_stock_out = StoreSalesAndStockHistory.where(channel_customer_id: cc_id, keterangan: "S").where("qty_out > ? and updated_at between ? and ?", 0, dari_tanggal, sampai_tanggal)
      @report_stock_return = StoreSalesAndStockHistory.where(channel_customer_id: cc_id, keterangan: "B").where("qty_out > ? and updated_at between ? and ?", 0, dari_tanggal, sampai_tanggal)

      respond_to do |format|
        format.html
        format.xls
      end
    end
  end

  def mutasi_stock
    @channel_customer = []
    channel = current_user.branch.present? ? current_user.branch.sales_counters : []
    if channel.present?
      current_user.branch.sales_counters.each do |sc|
        sc.recipients.group(:channel_customer_id).each do |scr|
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
