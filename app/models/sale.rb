class Sale < ActiveRecord::Base
  after_initialize :set_defaults
  has_many :sale_items, dependent: :destroy
  has_one :payment_with_debit_card, dependent: :destroy
  accepts_nested_attributes_for :payment_with_debit_card
  has_many :payment_with_credit_cards, dependent: :destroy
  accepts_nested_attributes_for :payment_with_credit_cards
  accepts_nested_attributes_for :sale_items, reject_if: proc { |a| a['kode_barang'].blank?}
  belongs_to :branch
  belongs_to :salesman
  belongs_to :item
  belongs_to :store
  belongs_to :showroom
  belongs_to :channel
  belongs_to :supervisor_exhibition
  belongs_to :channel_customer

  validates :customer, :phone_number, :alamat_kirim, :email, :netto, :netto_elite, :netto_lady, :tanggal_kirim, :kota, presence: true
  validates :phone_number, numericality: true, length: {maximum: 12}
  validates :no_kartu, numericality: true, if: :paid_with_credit?
  validates :no_kartu, numericality: true, if: :paid_with_debit?

  def set_defaults
    self.voucher = 0 if self.voucher.nil?
    self.netto = 0 if self.voucher.nil?
    self.pembayaran = 0 if self.voucher.nil?
  end

  before_create do
#    get_no_sale = Sale.where(store_id: self.store_id).size
#    get_no_sale.nil? ? (self.no_sale = 1) : (self.no_sale = get_no_sale + 1)
#    no_sale = self.no_sale.to_s.rjust(4, '0')
#    bulan = Date.today.strftime('%m')
#    tahun = Date.today.strftime('%y')
#    kode_customer = self.store.kode_customer
#    kode_cabang = self.store.branch.id.to_s.rjust(2, '0')
    first_code = ChannelCustomer.find(channel_customer_id).channel.kode
    self.no_so = loop do
      random_token = first_code + SecureRandom.hex.first(6)
      break random_token unless Sale.exists?(no_so: random_token)
    end
    self.voucher = voucher.nil? ? 0 : voucher
  end

  after_create do
    debit = self.payment_with_debit_card.jumlah.nil? ? 0 : self.payment_with_debit_card.jumlah
    credit = self.payment_with_credit_cards.nil? ? 0 : self.payment_with_credit_cards.sum(:jumlah)
    tunai = self.pembayaran
    total_bayar = debit + credit + tunai
    ket_lunas = total_bayar < (netto-self.voucher) ? 'um' : 'lunas'
    self.update_attributes!(cara_bayar: ket_lunas)
  end

  def paid_with_credit?
    tipe_pembayaran == 'kredit'
  end

  def paid_with_debit?
    tipe_pembayaran == 'debit'
  end
end
