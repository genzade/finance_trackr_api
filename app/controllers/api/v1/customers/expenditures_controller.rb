# frozen_string_literal: true

module Api
  module V1
    module Customers
      class ExpendituresController < ApplicationController

        def create
          form = Forms::Customers::CreateExpenditureForm.new(
            customer_id: params[:customer_id],
            params: expenditure_params
          )

          if form.save
            render(
              json: { message: I18n.t("customer.expenditure.created") },
              status: :created
            )
          else
            render_error(form.errors.full_messages, :unprocessable_entity)
          end
        end

        private

        def expenditure_params
          params.require(:expenditure).permit(:category, :amount)
        end

      end
    end
  end
end
