class ReportsController < ApplicationController
  def index
    @sales = SaleItem.all
  end
end
