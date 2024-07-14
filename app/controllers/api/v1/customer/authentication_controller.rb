# frozen_string_literal: true

module Api
  module V1
    module Customer
      class AuthenticationController < ApplicationController

        skip_before_action :authenticate_resource!, only: :create

        rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

        def create
          if authenticated_customer
            render(
              json: {
                message: I18n.t("customer.authentication.success"),
                data: authenticated_customer
              },
              status: :created
            )
          else
            render_error(I18n.t("customer.authentication.failure"), :unauthorized)
          end
        end

        private

        def handle_parameter_missing(error)
          render_error(error.message, :unprocessable_entity)
        end

        def authenticated_customer
          @authenticated_customer ||= Auths::CustomerAuthentication.call(
            email: auth_params.fetch(:email),
            password: auth_params.fetch(:password)
          )
        end

        def auth_params
          params.require(:customer).permit(:email, :password)
        end

      end
    end
  end
end
