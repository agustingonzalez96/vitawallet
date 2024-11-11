class PricesController < ApplicationController
  
  def welcome
    render json: { 
      messages: {
        general: "Bienvenido a la API de precios.",
        instructions: "Accede a /prices/show para obtener el precio actual de BTC en USD.",
        user_info: "Para obtener información sobre un usuario, usa /api/users/:id.",
        mas_info: "Para obtener la informacion detallada consulte el Readme.md"
      }
    }
  end

  def show
    begin
      price_btc = CoinDeskService.get_price
      render json: {currency: "BTC", price_in_usd: price_btc }, status: :ok
    rescue => e 
      render json: {error: e.message}, status: :error
    end
    
  end

  private
 
  def price_params
    params.require(:price).permit(:amount, :currency)
  end

end

