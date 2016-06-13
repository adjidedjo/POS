class PaymentWithDebitCard < ActiveRecord::Base
  belongs_to :sale, inverse_of: :payment_with_debit_cards

#  validates :no_kartu_debit, presence: true, if: :paid_with_debit?
#  validates :nama_kartu, presence: true, if: :paid_with_debit?
#  validates :atas_nama, presence: true, if: :paid_with_debit?

  def paid_with_debit?
    self.sale.tipe_pembayaran.split(";").include?("Debit Card")
  end
end
