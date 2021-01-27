Rails.application.routes.draw do
  get '/', to: 'sorns#search'

  get '/csv', to: 'sorns#csv'

  get '/search', to: 'sorns#search'

  get '/analytics', to: 'analytics#index'

  get '/about', to: 'pages#about'

  get '/help', to: 'pages#help'
end
