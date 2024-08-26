Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, format: 'json' do
    resources :name, only: %i[index]
  end
end
