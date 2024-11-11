class CoinDeskService
  include HTTParty
  base_uri 'https://api.coindesk.com/v1/bpi/currentprice'

  def self.get_price
    response = get('/BTC.json')
    if response.success?
      response['bpi']['USD']['rate_float']
    else
      raise "Error al obtener el precio de CoinDesk"
    end
  end
end