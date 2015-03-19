class PaymentWithDebitCard < ActiveRecord::Base
  belongs_to :sale
end
