Rails.application.routes.draw do
  get '/', to: 'pages#index'
  get '/table-everything', to: 'sorns#table_everything'
  get '/table-important', to: 'sorns#table_important'
  get '/cards-everything', to: 'sorns#cards_everything'
  get '/cards-important', to: 'sorns#cards_important'
  resources :sorns
  resources :agencies
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
