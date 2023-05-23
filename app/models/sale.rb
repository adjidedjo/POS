class Sale < ActiveRecord::Base
  after_initialize :set_defaults
  has_many :sale_items, inverse_of: :sale, dependent: :destroy
  has_many :payment_with_debit_cards, inverse_of: :sale, dependent: :destroy
  accepts_nested_attributes_for :payment_with_debit_cards
  has_many :payment_with_credit_cards, inverse_of: :sale, dependent: :destroy
  accepts_nested_attributes_for :payment_with_credit_cards
  accepts_nested_attributes_for :sale_items, allow_destroy: true, reject_if: proc { |a| a['kode_barang'].blank?}
  has_many :netto_sale_brands
  has_many :brands, through: :netto_sale_brands
  has_many :acquittances, dependent: :destroy
  belongs_to :branch
  belongs_to :salesman
  belongs_to :item
  belongs_to :store
  belongs_to :showroom
  belongs_to :channel
  belongs_to :supervisor_exhibition
  belongs_to :sales_promotion
  belongs_to :channel_customer
  belongs_to :pos_ultimate_customer
  belongs_to :bank_account

  has_paper_trail

  attr_accessor :nama, :email, :alamat, :kota, :no_telepon, :handphone, :handphone1, :nik, :nama_ktp, :alamat_ktp

  validates :netto, :tanggal_kirim, :netto_elite, :netto_lady,
    :netto_royal, :netto_serenity, :netto_tech, :voucher, :jumlah_transfer, :pembayaran, :sales_promotion_id, presence: true
  validates :nama, :email, :alamat, :kota, :no_telepon, presence: true, on: :create
  validates :sale_items, presence: {message: "BELUM ADA BARANG YANG DITAMBAHKAN"}, on: :create
  validates :so_manual, length: { maximum: 6 }, on: :create
  validates :netto, numericality: { greater_than: 0, message: "HARUS LEBIH DARI 0" }
  #  validates :no_kartu_debit, presence: true, if: :paid_with_debit?
  #  validates :jumlah_transfer, numericality: true, if: :paid_with_transfer?

  validate :uniqueness_of_items, :cek_pembayaran_tunai, :cek_pembayaran_transfer,
    :cek_pembayaran_debit, :cek_pembayaran_kredit,
    :cek_down_payment, :cek_transfer_bank

  def cek_transfer_bank
    if tipe_pembayaran.split(";").include?("Transfer") && bank_account_id.nil?
      errors.add(:"tipe_pembayaran", "SILAHKAN PILIH BANK TUJUAN TRANSFER")
    end
  end

  def self.search_for_acc(dari_tanggal, sampai_tanggal, cc)
    sales = where(channel_customer_id: cc) if cc.present?
    sales = sales.where("date(created_at) >=  ?", dari_tanggal) if dari_tanggal.present?
    sales = sales.where("date(created_at) <=  ?", sampai_tanggal) if sampai_tanggal.present?
    sales
  end

  def cek_netto_brand
    total_netto_brand = netto_elite + netto_lady + netto_serenity + netto_royal + netto_tech
    if total_netto_brand != netto
      errors.add(:netto, "JUMLAH NETTO BRANDS DAN NETTO TIDAK SAMA DENGAN NETTO")
    end
  end

  def uniqueness_of_items
    hash = {}
    sale_items.each do |si|
      unless si.serial.present? || si.bonus.present?
        if hash[si.kode_barang]
          errors.add(:kode_barang, "TIDAK BOLEH ADA BARANG YANG SAMA DALAM 1 SO")
          si.errors.add(:kode_barang, "has already been taken")
        end
        hash[si.kode_barang] = true
      end
    end
  end

  def cek_down_payment
    min_dp = (30 * netto)/100
    if sisa > (netto-min_dp)
      errors.add(:down_payment, "DP BELUM SESUAI DENGAN SYARAT & KETENTUAN")
    end
  end

  def netto_brand
    self.netto_lady = sale_items.select { |b| b[:kode_barang][2] == "L"}.sum(&:price_list)
    self.netto_elite = sale_items.select { |b| b[:kode_barang][2] == "E"}.sum(&:price_list)
    self.netto_serenity = sale_items.select { |b| b[:kode_barang][2] == "S"}.sum(&:price_list)
    self.netto_royal = sale_items.select { |b| b[:kode_barang][2] == "R"}.sum(&:price_list)
    self.netto_tech = sale_items.select { |b| b[:kode_barang][2] == "B"}.sum(&:price_list)
    self.netto_pure = sale_items.select { |b| b[:kode_barang][2] == "P"}.sum(&:price_list)
    # raise self.netto_elite.inspect    # raise self.netto_elite.inspect  # raise self.netto_elite.inspect
  end

  def cek_pembayaran_tunai
    if tipe_pembayaran.split(";").include?("Tunai") && pembayaran == 0
      errors.add(:pembayaran, "ISI JUMLAH PEMBAYARAN TUNAI SESUAI DENGAN NOMINAL TUNAI")
    end
  end

  def cek_pembayaran_transfer
    if tipe_pembayaran.split(";").include?("Transfer") && jumlah_transfer == 0
      errors.add(:jumlah_transfer, "ISI JUMLAH PEMBAYARAN TRANSFER SESUAI DENGAN NOMINAL")
    end
  end

  def cek_pembayaran_debit
    if tipe_pembayaran.split(";").include?("Debit Card") && payment_with_debit_cards.first.jumlah == 0
      errors.add(:"pembayaran_kartu_debit", "ISI JUMLAH PEMBAYARAN KARTU DEBIT SESUAI DENGAN NOMINAL")
    end
  end

  def cek_pembayaran_kredit
    if tipe_pembayaran.split(";").include?("Credit Card") && payment_with_credit_cards.first.jumlah == 0
      errors.add(:"pembayaran_kartu_kredit", "ISI JUMLAH PEMBAYARAN KARTU KREDIT SESUAI DENGAN NOMINAL")
    end
  end

  after_update do
    puc = {
      email: email,
      nama: nama,
      no_telepon: no_telepon,
      handphone: handphone,
      handphone1: handphone1,
      alamat: alamat,
      kota: kota,
      nik: nik.nil? ? '-' : nik,
      nama_ktp: nama_ktp.nil? ? nama : nama_ktp,
      alamat_ktp: alamat_ktp.nil? ? alamat : alamat_ktp,
    }
    if no_telepon.present?
      ultimate_customer = PosUltimateCustomer.where("no_telepon like ?", no_telepon)
      if ultimate_customer.empty?
        puc[:nama] = nama.titleize
        PosUltimateCustomer.create(puc)
      elsif ultimate_customer.first.no_telepon != "0"
        ultimate_customer.first.update_attributes!(puc)
      end
      self.pos_ultimate_customer_id = ultimate_customer.first.id
    end
  end

  def self.set_exported_items(sale_item)
    sale_item.each do |a|
      get_sale = Sale.find(a)
      if get_sale.sale_items.where(exported: false).blank?
        get_sale.update_attributes!(all_items_exported: true)
      end
    end
  end

  def ultimate_customer_name
    ultimate_customer.try(:name)
  end

  def ultimate_customer_name=(name)
    self.ultimate_customer_id = PosUltimateCustomer.find_or_create_by_nama(name).id if name.present?
  end

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
    #
    # create ultimate customer
    puc = {
      email: email,
      no_telepon: no_telepon,
      handphone: handphone,
      handphone1: handphone1,
      alamat: alamat,
      kota: kota
    }
    ultimate_customer = PosUltimateCustomer.where("no_telepon like ?", no_telepon)
    if ultimate_customer.empty?
      puc[:nama] = nama.titleize
      PosUltimateCustomer.create(puc)
    elsif ultimate_customer.first.no_telepon != "0"
      ultimate_customer.first.update_attributes!(puc)
    end
    self.pos_ultimate_customer_id = ultimate_customer.first.id
    # end create
    first_code = 'SOX'
    #    self.no_so = loop do
    #      random_token = first_code.upcase + Digest::SHA1.hexdigest([Time.now, rand].join)[0..7].upcase
    #      break random_token unless Sale.exists?(no_so: random_token.upcase)
    #    end
    self.voucher = voucher.nil? ? 0 : voucher
    last_order = Sale.where(channel_customer_id: channel_customer_id).last
    self.no_order = if last_order.present? && last_order.no_order.present?
      if last_order.no_order[0..1] == Date.today.strftime('%m')
        last_order.no_order.succ
      else
        (Date.today.strftime('%m') + Date.today.strftime('%y') + '0001')
      end
    else
      (Date.today.strftime('%m') + Date.today.strftime('%y') + '0001')
    end
    self.no_so = first_code + (sprintf '%03d', channel_customer_id) + self.no_order
  end

  after_create do
    debit = self.payment_with_debit_cards.nil? ? 0 : self.payment_with_debit_cards.sum(:jumlah)
    credit = self.payment_with_credit_cards.nil? ? 0 : self.payment_with_credit_cards.sum(:jumlah)
    tunai = self.pembayaran.nil? ? 0 : self.pembayaran
    transfer = self.jumlah_transfer.nil? ? 0 : self.jumlah_transfer
    total_bayar = debit + credit + tunai + transfer
    ket_lunas = total_bayar < (netto-self.voucher) ? 'um' : 'lunas'
    self.update_attributes!(cara_bayar: ket_lunas)
    Sale.generate_csv(self) if self.channel_customer_id == 1
    #UserMailer.order_pameran(self).deliver if self.channel_customer_id == 6
  end

  def self.generate_csv(data)
    attributes = %w{  order_id invoice_ref_num create_time product_id product_name sku quantity total_price recipient_name
    recipient_phone recipient_address address_line_1 address_line_2 address_line_3 logistics currency
  amt postal_code customer_po time fs_id} #customize columns here
    file_naming = "POS#{Time.now.strftime("%d%m%y%H%M")}"

    CSV.open("/home/marketing/shared_pos/SV/#{file_naming}.csv", "wb", headers: true, col_sep: ';') do |csv|
      csv << attributes
      data.sale_items.each do |si|
        brand_id = si.brand_id.to_s
        display = si.taken? ? "2" : ""


        csv << ["",si.sale.id, si.sale.no_so, "'#{si.sale.created_at.strftime("%d%m%y")}", si.id, si.nama_barang,
          si.kode_barang, si.jumlah, si.price_list, si.sale.pos_ultimate_customer.nama, si.sale.pos_ultimate_customer.handphone1,
          si.sale.pos_ultimate_customer.alamat, si.sale.pos_ultimate_customer.alamat.scan(/.{0,39}[a-z.!?,;](?:\b|$)/mi)[0],
          si.sale.pos_ultimate_customer.alamat.scan(/.{0,39}[a-z.!?,;](?:\b|$)/mi)[1], si.sale.pos_ultimate_customer.alamat.scan(/.{0,39}[a-z.!?,;](?:\b|$)/mi)[2],
          "internal", "IDR", si.id, "4018", si.sale.no_so, si.sale.created_at.to_i, (si.sale.channel_customer.id.to_s + brand_id + display)
        ]
      end
      File.write("/home/marketing/shared_pos/SV/OLORDER.txt", "#{file_naming}.csv|\n", mode: 'a')
    end
  end

  def paid_with_credit?
    tipe_pembayaran.split(";").include?("Credit Card")
  end

  def paid_with_debit?
    tipe_pembayaran.split(";").include?("Debit Card")
  end

  def paid_with_transfer?
    tipe_pembayaran.split(";").include?("Transfer")
  end
end
