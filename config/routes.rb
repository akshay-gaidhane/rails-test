Rails.application.routes.draw do
  get 'home/index'

  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :accounts do 
    resources :transactions do
      collection do
        get :transfer
        get :view_transactions
      end
    end
  end
end
