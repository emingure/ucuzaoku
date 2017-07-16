Rails.application.routes.draw do
  resources :books

  root 'home#index'

  resources :google
  resources :home
  resources :goodreads
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
