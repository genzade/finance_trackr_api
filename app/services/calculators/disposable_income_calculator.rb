# frozen_string_literal: true

module Calculators
  class DisposableIncomeCalculator

    def initialize(customer)
      @customer = customer
    end

    def call
      return nil if no_income_and_expenditure_records?

      customer_total_income_amount - customer_total_expenditure_amount
    end

    private

    attr_reader :customer

    delegate :incomes, :expenditures, to: :customer

    def no_income_and_expenditure_records?
      incomes.empty? && expenditures.empty?
    end

    def customer_total_income_amount
      incomes.sum(:amount)
    end

    def customer_total_expenditure_amount
      expenditures.sum(:amount)
    end

  end
end
