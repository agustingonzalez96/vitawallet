require 'rails_helper'

RSpec.describe TransactionService, type: :service do
  let(:user) { User.create!(balance_usd: 1000.0, balance_btc: 0.05) } # Ajusta según tu factory o método de creación
  let(:amount_to_send) { 100.0 }
  let(:currency_to_send) { "USD" }
  let(:currency_to_receive) { "BTC" }
  let(:transaction_service) { TransactionService.new(user, amount_to_send, currency_to_send, currency_to_receive) }

  describe "#process_buy_transaction" do
    it "debe actualizar el balance de USD después de la compra" do
      initial_balance = user.balance_usd
      transaction_service.process_buy_transaction
      user.reload 
      expect(user.balance_usd).to eq(initial_balance - 100.0)
    end

    it "debe actualizar el balance de BTC después de la compra" do
      initial_btc_balance = user.balance_btc
      transaction_service.process_buy_transaction
      user.reload
      expected_btc_balance = initial_btc_balance + (100.0 / CoinDeskService.get_price)
      expect(user.balance_btc).to be_within(0.0001).of(expected_btc_balance)
    end

    it "debe crear una transacción de compra" do
      expect { transaction_service.process_buy_transaction }.to change { Transaction.count }.by(1)
    end

    it "no debe permitir una transacción de compra si el saldo de USD es insuficiente" do
      initial_balance_usd = user.balance_usd.to_f
      
      transaction_service = TransactionService.new(user, (initial_balance_usd + 1).to_f, "USD", "BTC")
      
      expect { transaction_service.process_buy_transaction }.to raise_error('Insufficient USD balance')
    end

    it "debe procesar la compra de manera completa" do
      initial_btc_balance = user.balance_btc
      initial_usd_balance = user.balance_usd

      transaction_service.process_buy_transaction

      user.reload
      # Verificar que el balance de USD ha disminuido
      expect(user.balance_usd).to eq(initial_usd_balance - 100.0)
      # Verificar que el balance de BTC ha aumentado
      expected_btc_balance = initial_btc_balance + (100.0 / CoinDeskService.get_price)
      expect(user.balance_btc).to be_within(0.0001).of(expected_btc_balance)
      # Verificar que la transacción fue creada
      expect(Transaction.count).to eq(1)
    end
  end

  describe "#process_sell_transaction" do
    it "debe procesar una transacción de venta correctamente" do
      transaction_service = TransactionService.new(user, 50.0, "USD", "BTC")
      transaction_service.process_sell_transaction
      user.reload
      expected_btc_balance = user.balance_btc - 50.0 / CoinDeskService.get_price
      expect(user.balance_btc).to be_within(0.0001).of(expected_btc_balance)
    end
  end
end