class BankAccount < ActiveRecord::Base
  has_many :sale
end
