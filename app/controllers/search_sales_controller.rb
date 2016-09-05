class SearchSalesController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :show, :index, :create, :update]
  before_action :get_id, only: [:show, :edit, :update, :destroy]
  
  def penjualan
    raise params[:id].inspect
    
    
    respond_to do |format|
      format.xls
    end
  end

  def index
    unless current_user.admin?
      @brand = Brand.all
      @channel_customer = current_user.channel_customer
      @top_10_items = SaleItem.select('kode_barang, sum(jumlah) as sum_jumlah')
      .where("kode_barang not like ? and kode_barang not like ? and cancel = ? and channel_customer_id = ?", "#{'E'}%", "#{'L'}%", 0, @channel_customer.id)
      .group(:kode_barang).order('sum_jumlah DESC').limit(10)
      @top_pc = @channel_customer.sales.select('*, sales_promotion_id, sum(netto_elite) as elite, sum(netto_lady) as lady')
      .where("cancel_order = ?", 0).group(:sales_promotion_id).order('elite DESC, lady DESC').limit(10)
    end
  end

  def new
    @search = SearchSale.new
    if current_user
      if current_user.role.nil?
        @channel_customer = current_user.channel_customer
      elsif current_user.role == "controller" || current_user.role == "admin"
        @channel_customer = ChannelCustomer.order(:nama)
      else
        @channel_customer = []
        current_user.branch.sales_counters.group(:branch_id).each do |sc|
          sc.recipients.group(:channel_customer_id, :sales_counter_id).each do |scr|
            @channel_customer << scr.channel_customer
          end
        end
      end
    else
      @channel_customer = ChannelCustomer.order(:nama)
    end
  end

  def create
    @search = SearchSale.new(search_sale_params)

    respond_to do |format|
      if @search.save
        format.html {redirect_to @search}
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    if current_user
      @user = current_user.channel_customer.id
      unless current_user.admin?
        @brand = Brand.all
        @cc = current_user.present? ? current_user.channel_customer : ChannelCustomer.find(self.channel_customer_id)
        @top_10_items = []
        @sale_items = []
        @cc.sales.where('date(created_at) between ? and ?', @search.dari_tanggal, @search.sampai_tanggal).each do |sa|
          @top_10_items << sa.sale_items.select('kode_barang, sum(jumlah) as sum_jumlah').where("kode_barang not like ? and kode_barang not like ? and cancel = ? and channel_customer_id = ?", "#{'E'}%", "#{'L'}%", 0, @cc.id)
          .group(:kode_barang).order('sum_jumlah DESC').limit(10)
        end
        @cc.sales.where('date(created_at) between ? and ?', @search.dari_tanggal, @search.sampai_tanggal).each do |sa|
          @sale_items << sa.sale_items
        end
        @top_pc = @cc.sales.select('*, sales_promotion_id, sum(netto) netto')
        .where("date(created_at) >= ? and date(created_at) <= ? and cancel_order = ?",
          @search.dari_tanggal, @search.sampai_tanggal,0).group(:sales_promotion_id)
      else
        show_without_user
      end
    else
      show_without_user
    end
    
    respond_to do |format|
      format.html
      format.xls {headers["Content-Disposition"] = "attachment; filename=\"Penjualan-#{@search.dari_tanggal} to #{@search.sampai_tanggal}\"" }
    end
  end

  def update
    @search.update_attributes!(search_sale_params)
    redirect_to @search
  end

  private

  def get_id
    @search = SearchSale.find(params[:id])
  end

  def search_sale_params
    params.require(:search_sale).permit(:keywords, :channel_id, :channel_customer_id, :dari_tanggal, :sampai_tanggal, :tampilkan_berdasarkan)
  end

  def show_without_user
    @brand = Brand.all
    @channel_customer = ChannelCustomer.order(:nama)
    @cc = ChannelCustomer.find(SearchSale.find(params[:id]).channel_customer_id)
    @top_10_items = []
    @sale_items = []
    @cc.sales.where('date(created_at) between ? and ?', @search.dari_tanggal, @search.sampai_tanggal).each do |sa|
      @top_10_items << sa.sale_items.select('kode_barang, sum(jumlah) as sum_jumlah').where("kode_barang not like ? and kode_barang not like ? and cancel = ? and channel_customer_id = ?", "#{'E'}%", "#{'L'}%", 0, @cc.id)
        .group(:kode_barang).order('sum_jumlah DESC').limit(10)
    end
    @cc.sales.where('date(created_at) between ? and ?', @search.dari_tanggal, @search.sampai_tanggal).each do |sa|
      @sale_items << sa.sale_items
    end
    @top_pc = @cc.sales.select('*, sales_promotion_id, sum(netto) netto')
     .where("date(created_at) >= ? and date(created_at) <= ? and cancel_order = ?",
     @search.dari_tanggal, @search.sampai_tanggal,0).group(:sales_promotion_id)
  end
end