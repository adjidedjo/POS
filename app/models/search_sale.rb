class SearchSale < ActiveRecord::Base
  validates :dari_tanggal, :sampai_tanggal, :tampilkan_berdasarkan, presence: true

  def sales
    @sales = find_sales
  end

  def self.report_by_brand(dari, sampai, user, brand, stock)
    if brand.present?
      SaleItem.where(channel_customer_id: user, cancel: false, brand_id: brand, stocking_type: stock).where("date(created_at) >= ? and date(created_at) <= ?",
        dari, sampai).sum(:price_list)
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
    sales = sales.where("date(created_at) >= ?", dari_tanggal) if dari_tanggal.present?
    sales = sales.where("date(created_at) <= ?", sampai_tanggal) if sampai_tanggal.present?
    sales
  end
end
