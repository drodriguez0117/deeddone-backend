Rails.application.routes.draw do
  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy

  #scope module: 'api' do
  #  scope module: 'v1' do
  #    resources :listings
  #  end
  #end

  namespace :api do
    namespace :v1 do
      resources :listings
      #resources :users do
      # resource listings
      #
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
