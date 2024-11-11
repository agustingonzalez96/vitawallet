class Api::TransactionsController < ApplicationController
  def create_buy

    @user = User.find(params[:user_id])
    
    transaction_service = TransactionService.new(
      @user,
      params[:amount_to_send],
      params[:currency_to_send],
      params[:currency_to_receive]
    )

    result = transaction_service.process_buy_transaction
    render json: result
  end

  # Endpoint para crear una transacción de venta
  def create_sell
    @user = User.find(params[:user_id])

    transaction_service = TransactionService.new(
      @user,
      params[:amount_to_send],
      params[:currency_to_send],
      params[:currency_to_receive]
    )

    result = transaction_service.process_sell_transaction
    render json: result
  end

  def info
    render json: { message: "Para realizar una transaccion de Compra debe ir a la url '{url}/api/transactions/1/buy' en postman" }
  end

  def index
    user = User.find(params[:user_id])

    transactions = user.transactions

    render json: {
      user_id: user.id,
      balance_usd: format('%.2f', user.balance_usd),
      balance_btc: format('%.8f', user.balance_btc),
      transactions: transactions
    }
  end

  def show
    transaction = Transaction.find(params[:id])
    render json: transaction
  end
end

