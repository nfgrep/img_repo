# frozen_string_literal: true
Rails.application.routes.draw do
  resources :images do
    get "search/:query", on: :collection, action: "search", as: "search"
    get ":size", on: :member, action: "show"
  end
end
