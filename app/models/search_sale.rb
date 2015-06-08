class SearchSale < ActiveRecord::Base
  def sales
    @sales = find_sales
  end

  def self.report_by_brand(user, brand)
    if brand.present? && brand == 4
      Sale.where(channel_customer_id: user).sum(:netto_lady) if brand.present? && brand == 4
    elsif brand.present? && brand == 2
      Sale.where(channel_customer_id: user).sum(:netto_elite) if brand.present? && brand == 2
    else
      return 0
    end
  end

private
  def find_sales
    sales = Sale.where(cancel_order: false).order(:no_so)
    sales = sales.where("no_so like ?", "%#{keywords}%") if keywords.present?
    sales = sales.where(channel_customer_id: channel_customer_id) if channel_customer_id.present?
    sales = sales.where(channel_id: channel_id) if channel_id.present?
    sales
  end
end
