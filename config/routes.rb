Rails.application.routes.draw do
  post 'login', controller: :login, action: :create
  post 'register', controller: :register, action: :create

  scope module: 'api/v1' do
    resources :listings, only: %i[index show]
  end

  scope module: 'api/v1/admin', path: 'admin', as: 'admin' do
    resources :listings
    resources :categories, only: %i[index]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
