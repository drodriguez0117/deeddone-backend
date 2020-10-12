Rails.application.routes.draw do
  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy

  scope module: 'api/v1' do
    resources :listings, only: [:index, :show]
  end

  scope module: 'api/v1/admin', path: 'admin', as: 'admin' do
    resources :listings
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
