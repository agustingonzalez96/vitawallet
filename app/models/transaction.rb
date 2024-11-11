class Transaction < ApplicationRecord
  belongs_to :user

  def self.calculate_btc(amount_usd, btc_price)
    amount_btc = amount_usd / btc_price
    amount_btc
  end

end
