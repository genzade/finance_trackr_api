# frozen_string_literal: true

module Api
  module V1
    module Customers
      class IncomesController < ApplicationController

        def create
          form = Forms::Customers::CreateIncomeForm.new(
            customer_id: params[:customer_id],
            params: income_params
          )

          if form.save
            render(
              json: { message: I18n.t("customer.income.created") },
              status: :created
            )
          else
            render_error(form.errors.full_messages, :unprocessable_entity)
          end
        end

        private

        def income_params
          params.require(:income).permit(:source, :amount)
        end

      end
    end
  end
end
