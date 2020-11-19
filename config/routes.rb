Rails.application.routes.draw do
  get '/', to: 'pages#index'
  get '/table-everything', to: 'sorns#table_everything'
  get '/table-important', to: 'sorns#table_important'
  get '/cards-everything', to: 'sorns#cards_everything'
  get '/cards-important', to: 'sorns#cards_important'
  get '/systems', to: 'sorns#systems'

  get '/bulk/table-everything', to: 'sorns#bulk_table_everything'
  get '/bulk/table-important', to: 'sorns#bulk_table_important'
  get '/bulk/cards-everything', to: 'sorns#bulk_cards_everything'
  get '/bulk/cards-important', to: 'sorns#bulk_cards_important'

  get '/csv', to: 'sorns#csv'

  get '/search', to: 'sorns#search'
  get '/search-old', to: 'sorns#search_old'

  get '/analytics', to: 'analytics#index'

  get '/about', to: 'pages#about'

  resources :sorns
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
