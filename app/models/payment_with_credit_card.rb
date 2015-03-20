class PaymentWithCreditCard < ActiveRecord::Base
  belongs_to :sale

  before_create do
    self.nama_kartu = Merchant.find_by_no_merchant(no_kartu).nil? ? '' : Merchant.find_by_no_merchant(no_kartu).nama
  end
end
