Rails.application.routes.draw do
  devise_for :users

  root "dashboard#index"

  resources :students do
    resource :health_record, only: %i[show new create edit update]
  end

  resources :plans
  resources :enrollments, only: %i[new create destroy]
  resources :payments, only: %i[index show edit update destroy]

  namespace :public do
    get  "/:academy_slug", to: "registrations#new",    as: :registration
    post "/:academy_slug", to: "registrations#create"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
