require 'action_dispatch/middleware/static'
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/", to: "home#index"

  namespace :api do
    namespace :v1 do
      # /api/v1/xxx
      resources :validation_codes, only: [:create]
      resource :session, only: [:create, :destroy]
      resource :me, only: [:show]
      resource :refresh_jwt, only: [:show]
      resources :tags
      resources :items do 
        collection do 
          get :balance
          get :summary
        end
      end
    end
  end
end
