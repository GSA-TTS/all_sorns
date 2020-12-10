Rails.application.routes.draw do
  get '/', to: 'sorns#search'

  get '/csv', to: 'sorns#csv'

  get '/search', to: 'sorns#search'

  get '/analytics', to: 'analytics#index'

  get '/about', to: 'pages#about'

  resources :sorns
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
