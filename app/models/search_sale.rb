class SearchSale < ActiveRecord::Base
  def sales
    @sales = find_sales
  end

private
  def find_sales
    sales = Sale.order(:no_so)
    sales = sales.where("no_so like ?", "%#{keywords}%") if keywords.present?
    sales = sales.where(channel_customer_id: channel_customer_id) if channel_customer_id.present?
    sales
  end
end