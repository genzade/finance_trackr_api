# frozen_string_literal: true

module Forms
  module Customers
    class UpdateStatementForm

      include ActiveModel::Model

      attr_accessor :statement

      def initialize(statement:, params: {})
        @statement = statement

        super(params)
      end

      def save
        statement.disposable_income_amount = calculate_disopable_income
        statement.ie_rating = calculate_ie_rating

        statement.save
      end

      private

      delegate :customer, to: :statement

      def total_income_amount
        customer.incomes.sum(:amount)
      end

      def total_expenditure_amount
        customer.expenditures.sum(:amount)
      end

      def calculate_disopable_income
        Calculators::DisposableIncomeCalculator.call(
          total_income: total_income_amount,
          total_expenditure: total_expenditure_amount
        )
      end

      def calculate_ie_rating
        Calculators::IeRatingCalculator.call(
          total_income: total_income_amount,
          total_expenditure: total_expenditure_amount
        )
      end

    end
  end
end
