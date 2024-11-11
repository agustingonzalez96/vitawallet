Rails.application.routes.draw do
  root 'prices#welcome'
  get '/prices/show', to: 'prices#show'

  resources :prices, only: [:index, :show]

  namespace :api do
    resources :users, only: [:show] do
      resources :transactions, only: [:index, :create] do
        collection do
          post 'buy', to: 'transactions#create_buy'
          post 'sell', to: 'transactions#create_sell'
        end
      end
    end
  end
end
