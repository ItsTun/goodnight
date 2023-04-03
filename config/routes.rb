Rails.application.routes.draw do
  apipie
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  scope 'api/v1', defaults: { format: :json } do
    # sleep_records
    post 'clock_in', to: 'api/v1/sleep_records#clock_in'
    get 'sleep_records', to: 'api/v1/sleep_records#index'
    get 'friends_sleep_records', to: 'api/v1/sleep_records#friends_sleep_records'

    # users
    post 'follow', to: 'api/v1/users#follow'
    post 'unfollow', to: 'api/v1/users#unfollow'
  end
end
