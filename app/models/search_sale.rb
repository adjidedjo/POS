class SearchSale < ActiveRecord::Base
  validates :dari_tanggal, :sampai_tanggal, :tampilkan_berdasarkan, presence: true

  def sales
    @sales = find_sales
  end

  def self.report_by_brand(dari, sampai, user, brand)
    if brand.present? && brand == 4
      Sale.where(channel_customer_id: user, cancel_order: false).where("date(created_at) >= ? and date(created_at) <= ?",
        dari, sampai).sum(:netto_lady) if brand.present? && brand == 4
    elsif brand.present? && brand == 2
      Sale.where(channel_customer_id: user, cancel_order: false).where("date(created_at) >= ? and date(created_at) <= ?",
        dari, sampai).sum(:netto_elite) if brand.present? && brand == 2
    elsif brand.present? && brand == 6
      Sale.where(channel_customer_id: user, cancel_order: false).where("date(created_at) >= ? and date(created_at) <= ?",
        dari, sampai).sum(:netto_serenity) if brand.present? && brand == 6
    elsif brand.present? && brand == 7
      Sale.where(channel_customer_id: user, cancel_order: false).where("date(created_at) >= ? and date(created_at) <= ?",
        dari, sampai).sum(:netto_tech) if brand.present? && brand == 7
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
