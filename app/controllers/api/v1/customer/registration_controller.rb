# frozen_string_literal: true

module Api
  module V1
    module Customer
      class RegistrationController < ApplicationController

        skip_before_action :authenticate_resource!

        def create
          form = Forms::Customers::RegistrationForm.new(registration_params)

          if form.save
            render(
              json: { message: I18n.t("customer.registration.success") },
              status: :created
            )
          else
            render_error(form.errors.full_messages, :unprocessable_entity)
          end
        end

        private

        def registration_params
          params.permit(:email, :password, :password_confirmation)
        end

      end
    end
  end
end
