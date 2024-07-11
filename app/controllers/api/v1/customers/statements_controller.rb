# frozen_string_literal: true

module Api
  module V1
    module Customers
      class StatementsController < ApplicationController

        def show
          render json: {
            message: I18n.t("customer.statement.show.success"),
            data: {
              income: customer_incomes,
              expenditure: customer_expenditures,
              ie_rating: statement.ie_rating.humanize.titleize,
              disposable_income_amount: statement.disposable_income_amount
            }
          }
        end

        private

        def statement
          @statement ||= Statement.find_by(customer: customer)
        end

        def customer
          @customer ||= ::Customer.find_by(id: params[:customer_id])
        end

        def customer_expenditures
          Expenditure.where(customer: customer).map do |expenditure|
            expenditure.attributes.slice("category", "amount")
          end
        end

        def customer_incomes
          Income.where(customer: customer).map do |income|
            income.attributes.slice("source", "amount")
          end
        end

      end
    end
  end
end
