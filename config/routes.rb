# frozen_string_literal: true
Rails.application.routes.draw do
  resources :images do
    get 'search', on: :collection, as: :search
  end
end
