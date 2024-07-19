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

    def total_income_amount(customer)
      customer.incomes.sum(:amount)
    end

    def total_expenditure_amount(customer)
      customer.expenditures.sum(:amount)
    end

    def calculate_disopable_income(customer)
      Calculators::DisposableIncomeCalculator.call(
        total_income: total_income_amount(customer),
        total_expenditure: total_expenditure_amount(customer)
      )
    end

    def calculate_ie_rating(customer)
      Calculators::IeRatingCalculator.call(
        total_income: total_income_amount(customer),
        total_expenditure: total_expenditure_amount(customer)
      )
    end

  end
end
