# frozen_string_literal: true

module Calculators
  class BaseCalculator

    def self.call(...)
      new(...).call
    end

    def initialize(customer)
      @customer = customer
    end

    def call
      raise NotImplementedError
    end

    private

    attr_reader :customer

    delegate :incomes, :expenditures, to: :customer

    def no_income_and_expenditure_records?
      incomes.empty? && expenditures.empty?
    end

    def total_income_amount
      incomes.sum(:amount)
    end

    def total_expenditure_amount
      expenditures.sum(:amount)
    end

  end
end
