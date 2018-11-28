Rails.application.routes.draw do

  post 'reports', to: 'reports#create', as: 'reports'
  get 'reports/:token', to: 'reports#show', as: 'report'
  get 'reports/:token/json', to: 'reports#show_json'
  put 'reports/:token/result', to: 'reports#update_result'
  put 'reports/:token/time', to: 'reports#update_time'

  get 'healthcheck', to: 'ok_computer/ok_computer#index'

end
