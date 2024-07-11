# frozen_string_literal: true

module Customers
  class UpdateStatementJob < BaseJob

    def perform(customer_id)
      customer ||= Customer.find_by(id: customer_id)
      statement ||= Statement.find_by(customer: customer)

      statement.disposable_income_amount = calculate_disopable_income(customer)
      statement.ie_rating = calculate_ie_rating(customer)

      statement.save
    end

    private

    def calculate_disopable_income(customer)
      Calculators::DisposableIncomeCalculator.new(customer).call
    end

    def calculate_ie_rating(customer)
      Calculators::IeRatingCalculator.new(customer).call
    end

  end
end
