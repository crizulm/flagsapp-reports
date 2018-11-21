Rails.application.routes.draw do

  post 'reports', to: 'reports#create', as: 'reports'
  get 'reports/:token', to: 'reports#show', as: 'report'
  put 'reports/:token', to: 'reports#update'
  get 'reports/:token/json', to: 'reports#show_json'

end
