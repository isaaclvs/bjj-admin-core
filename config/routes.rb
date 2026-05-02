Rails.application.routes.draw do
  devise_for :users

  root "dashboard#index"

  resources :students do
    resource :health_record, only: %i[show new create edit update]
  end

  resources :plans, except: %i[show]
  resources :enrollments, only: %i[index new create destroy]
  resources :payments, except: %i[show]
  resources :users, only: %i[index new create destroy]
  resource  :academy, only: %i[edit update]

  namespace :public do
    get  "/:academy_slug", to: "registrations#new",    as: :registration
    post "/:academy_slug", to: "registrations#create"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
