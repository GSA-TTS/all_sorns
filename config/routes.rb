Rails.application.routes.draw do
  get '/', to: 'search#index'

  get '/search', to: 'search#search'

  get '/analytics', to: 'analytics#index', format: false

  get '/about', to: 'pages#about', format: false

  get '/help', to: 'pages#help', format: false
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
