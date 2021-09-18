Rails.application.routes.draw do
  root "images#index"
  
  resources :images do
    collection do
      get 'search(/:query)', :to => "images#search", as: 'search'
    end
  end

end
