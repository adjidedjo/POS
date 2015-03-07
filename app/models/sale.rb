class Sale < ActiveRecord::Base
  has_many :sale_items, dependent: :destroy
  accepts_nested_attributes_for :sale_items
  belongs_to :branch
  belongs_to :salesman
  belongs_to :item
  belongs_to :store
  belongs_to :channel

  validates :salesman_id, :spg, :customer, :phone_number, :alamat_kirim, :channel_id, :store_id, :email, presence: true
  validates :phone_number, numericality: true, length: {maximum: 12}
  validates :nama_kartu, :no_kartu, :no_merchant, :atas_nama, presence: true, if: :paid_with_card?
  validates :no_kartu, :no_merchant, numericality: true, if: :paid_with_card?

  before_create do
    get_no_sale = Sale.where("month(created_at)", Date.today.month).count(:id)
    get_no_sale.nil? ? (self.no_sale = 1) : (self.no_sale = get_no_sale + 1)
    no_sale = self.no_sale.to_s.rjust(4, '0')
    bulan = Date.today.strftime('%m')
    tahun = Date.today.strftime('%y')
    kode_customer = self.store.kode_customer
    kode_cabang = self.store.branch.id.to_s.rjust(2, '0')
    self.no_so = 'SOM''-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
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
