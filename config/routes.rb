Rails.application.routes.draw do
  get '/', to: 'sorns#index'
  get '/table', to: 'sorns#table'
  get '/cards', to: 'sorns#index'
  resources :sorns
  resources :agencies
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
