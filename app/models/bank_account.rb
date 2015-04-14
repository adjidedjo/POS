class BankAccount < ActiveRecord::Base
  has_many :sale
  has_many :acquittances
end
