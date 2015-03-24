class PaymentWithCreditCard < ActiveRecord::Base
  belongs_to :sale

  before_create do
    self.nama_merchant = Merchant.find_by_no_merchant(no_merchant).nil? ? '' : Merchant.find_by_no_merchant(no_merchant).nama
  end
end
