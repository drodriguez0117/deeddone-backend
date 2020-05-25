Rails.application.routes.draw do
  get 'signin/create'
  get 'signup/create'

  namespace :api do
    namespace :v1 do
      resources :listings
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
