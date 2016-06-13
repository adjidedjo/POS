class AcquittanceWithCreditCard < ActiveRecord::Base
  belongs_to :acquittance, inverse_of: :payment_with_credit_cards
end
