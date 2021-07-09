class AcquittanceWithDebitCard < ActiveRecord::Base
  belongs_to :acquittance, inverse_of: :payment_with_debit_card
end
