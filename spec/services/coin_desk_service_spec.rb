require 'rails_helper'

describe CoinDeskService do
  describe '.get_price' do
    it 'devuelve el precio actual de BTC en USD dentro de un rango esperado' do
      allow(HTTParty).to receive(:get).and_return(double('response', body: { bpi: { USD: { rate_float: 76294.8058 } } }.to_json))

      result = CoinDeskService.get_price

      expect(result).to be_within(1000).of(76294.8058)
    end
  end
end

