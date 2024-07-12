# frozen_string_literal: true

module Api
  module V1
    module Customer
      class AuthenticationController < ApplicationController

        rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

        def create
          customer = ::Customer.find_by(email: auth_params.fetch(:email))
          customer_password = auth_params.fetch(:password)

          if customer&.authenticate(customer_password)
            render(
              json: {
                message: I18n.t("customer.authentication.success"),
                token: "123" # TODO: implement something like JWT here instead
              },
              status: :created
            )
          else
            render(
              json: { errors: I18n.t("customer.authentication.failure") },
              status: :unauthorized
            )
          end
        end

        private

        def handle_parameter_missing(error)
          render(
            json: { errors: error.message },
            status: :unprocessable_entity
          )
        end

        def auth_params
          params.require(:customer).permit(:email, :password)
        end

      end
    end
  end
end
