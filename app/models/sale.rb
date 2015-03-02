class Sale < ActiveRecord::Base
  has_many :sale_items, dependent: :destroy
  accepts_nested_attributes_for :sale_items
  belongs_to :branch
  belongs_to :salesman
  belongs_to :showroom
  belongs_to :venue
  belongs_to :item
  belongs_to :store
  belongs_to :channel

  validates :salesman_id, :spg, :customer, :phone_number, :alamat_kirim, :channel_id, :store_id, presence: true
  validates :phone_number, numericality: true, length: {maximum: 12}
  validates :nama_kartu, :no_kartu, :no_merchant, :atas_nama, presence: true, if: :paid_with_card?
  validates :no_kartu, :no_merchant, numericality: true, if: :paid_with_card?

  before_create do
    get_no_sale = Sale.where(created_at: Date.today.to_datetime).count(:id)
    get_no_sale.nil? ? (self.no_sale = 1) : (self.no_sale = get_no_sale + 1)
    if pembayaran < netto
      self.cara_bayar = 'um'
    else
      self.cara_bayar = 'lunas'
    end
  end

  def paid_with_card?
    tipe_pembayaran == 'kartu'
  end
end
