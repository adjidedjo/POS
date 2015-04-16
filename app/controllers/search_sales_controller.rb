class SearchSalesController < ApplicationController
  before_action :get_id, only: [:show, :edit, :update, :destroy]

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
    params.require(:search_sale).permit(:keywords, :channel_id, :channel_customer_id)
  end
end
