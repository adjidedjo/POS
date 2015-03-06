class ReportsController < ApplicationController
  def index
    @sales = SaleItem.all if current_user.admin?
    @sales = User.find(current_user.id).sale_items unless current_user.admin?
  end
end
