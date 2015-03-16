class Store < ActiveRecord::Base
  has_many :sales
  has_many :merchants, dependent: :destroy
  accepts_nested_attributes_for :merchants, reject_if: proc { |a| a['no_merchant'].blank?}
  has_one :supervisor_exhibition, dependent: :destroy
  accepts_nested_attributes_for :supervisor_exhibition, reject_if: proc { |attributes| attributes['nama'].blank? }
  has_many :sales_promotions, dependent: :destroy
  accepts_nested_attributes_for :sales_promotions, reject_if: proc { |attributes| attributes['nama'].blank?}
  has_many :exhibition_stock_items
  belongs_to :channel
  belongs_to :branch

#  validates :nama, :kota, :from_period, :to_period, :branch_id, :stock_items, :channel_id, presence: true
#  validates :stock_items, presence: true

#  before_create do
#    self.kode_customer = SecureRandom.hex.first(4).upcase
#  end
end
