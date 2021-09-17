Rails.application.routes.draw do
  root "images#index"
  resources :images
  get :search, to: 'search#search'
end
