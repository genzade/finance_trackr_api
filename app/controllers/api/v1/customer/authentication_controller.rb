# frozen_string_literal: true

module Api
  module V1
    module Customer
      class AuthenticationController < ApplicationController

        skip_before_action :authenticate_resource!, only: :create

        rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

        def create
          password = auth_params.fetch(:password)

          if customer&.authenticate(password)
            token = Auths::JsonWebToken.encode(
              { resource_id: customer.id, resource_type: customer.class.name }
            )

            render(
              json: {
                message: I18n.t("customer.authentication.success"),
                token: token
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

        def customer
          @customer ||= ::Customer.find_by(email: auth_params.fetch(:email))
        end

        def auth_params
          params.require(:customer).permit(:email, :password)
        end

      end
    end
  end
end
