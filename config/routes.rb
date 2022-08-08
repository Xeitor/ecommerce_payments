Rails.application.routes.draw do
  resources :payments, except: [:update, :create, :destroy]
  resources :payment_methods, except: :update
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
