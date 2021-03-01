Rails.application.routes.draw do
  get '/', to: 'search#index'

  post '/search', to: 'search#search'
  get '/search', to: 'search#search' #pagination uses GET

  get '/csv', to: 'search#csv'

  get '/analytics', to: 'analytics#index'

  get '/about', to: 'pages#about'

  get '/help', to: 'pages#help'
end
