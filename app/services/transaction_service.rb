class TransactionService
  attr_reader :user, :amount_to_send, :currency_to_send, :currency_to_receive

  def initialize(user, amount_to_send, currency_to_send, currency_to_receive)
    @user = user
    @amount_to_send = amount_to_send
    @currency_to_send = currency_to_send
    @currency_to_receive = currency_to_receive
  end

  # Procesar transacción de compra
  def process_buy_transaction
    process_transaction("buy")
  end

  # Procesar transacción de venta
  def process_sell_transaction
    process_transaction("sell")
  end

  private

  # Método para procesar la transacción de compra o venta
  def process_transaction(type)
    ActiveRecord::Base.transaction do
      validate_balance!(currency_to_send)
      amount_to_receive = calculate_amount_to_receive

      transaction = user.transactions.create!(
        transaction_type: type,
        amount_usd: currency_to_send == "USD" ? amount_to_send : amount_to_receive,
        amount_btc: currency_to_send == "BTC" ? amount_to_send : amount_to_receive,
        balance_usd_at_transaction: user.balance_usd,
        balance_btc_at_transaction: user.balance_btc
      )

      update_user_balance!(amount_to_receive, type)

      transaction
    end
  rescue StandardError => e
    { error: e.message }
  end

  def validate_balance!(currency)
    if currency == "USD" && user.balance_usd < amount_to_send
      raise "Insufficient USD balance"
    elsif currency == "BTC" && user.balance_btc < amount_to_send
      raise "Insufficient BTC balance"
    end
  end

  # Calcular la cantidad a recibir según el tipo de transacción
  def calculate_amount_to_receive
    exchange_rate = CoinDeskService.get_price
    currency_to_send == "USD" ? amount_to_send / exchange_rate : amount_to_send * exchange_rate
  end

  # Actualizar el balance del usuario después de la transacción
  def update_user_balance!(amount_to_receive, type)
    if type == "buy"
      user.update!(
        balance_usd: user.balance_usd - amount_to_send,
        balance_btc: user.balance_btc + amount_to_receive
      )
    else
      user.update!(
        balance_usd: user.balance_usd + amount_to_receive,
        balance_btc: user.balance_btc - amount_to_send
      )
    end
  
    user.reload  
  end
end