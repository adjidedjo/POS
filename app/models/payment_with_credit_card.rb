class PaymentWithCreditCard < ActiveRecord::Base
  belongs_to :sale

  before_create do
    get_nama_merchant = Merchant.find_by_no_merchant(no_merchant)
    self.nama_merchant = get_nama_merchant.nil? ? '' : get_nama_merchant.nama
    get_mid = Merchant.find_by_mid(tenor)
    self.tenor = get_mid.nil? ? '' : get_mid.tenor
    self.mid = get_mid.nil? ? '' : get_mid.mid
  end
end