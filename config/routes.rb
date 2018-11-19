Rails.application.routes.draw do

  get 'reports/json', to: 'reports#get_json_report'
  get 'reports', to: 'reports#get_report'
  post 'reports', to: 'reports#create_report'
  put 'reports', to: 'reports#update_report'

end
