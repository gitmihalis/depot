Rails.application.routes.draw do

  get 'admin' => 'admin#index'

  resources :products do
    get :who_bought, on: :member
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  scope '(:locale)' do
    resources :users
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: 'store_index', via: :all
  end



end
