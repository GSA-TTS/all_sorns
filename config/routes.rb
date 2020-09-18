Rails.application.routes.draw do
  resources :sorns
  resources :agencies
  get '/search', to: 'search#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
