class SearchSalesController < ApplicationController
  before_action :get_id, only: [:show, :edit, :update, :destroy]

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
  end

  def create
    @search = SearchSale.create!(search_sale_params)
    redirect_to @search
  end

  def show
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
    params.require(:search_sale).permit(:keywords, :channel_id, :channel_customer_id, :dari_tanggal, :sampai_tanggal)
  end
end
