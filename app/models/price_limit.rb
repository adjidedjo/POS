class PriceLimit < ActiveRecord::Base
  def self.checking_limit_prices(item_number, img)
    find_by_sql("SELECT limit_price, period_to FROM price_limits WHERE item_number = '#{item_number}' AND channel_customer_id = '#{img}'").first
  end
end
