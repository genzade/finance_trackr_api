# frozen_string_literal: true

module Api
  module V1
    module Customers
      class StatementController < ApplicationController

        def show
          # @statement = Statement.find_by(customer: params[:customer_id])

          # render json: {
          #   message: I18n.t("customer.statement.show.success"),
          #   data: {
          #     income: @statement.incomes,
          #     expenditure: @statement.expenditures
          #   }
          # }
        end

      end
    end
  end
end
