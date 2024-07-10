# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :customer do
        post :registration, to: "registration#create"
      end

      resources :customers, only: [] do
        resource :statement, only: :show, module: :customers
        resource :income, only: :create, module: :customers
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
