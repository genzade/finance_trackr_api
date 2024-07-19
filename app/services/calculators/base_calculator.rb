# frozen_string_literal: true

module Calculators
  class BaseCalculator

    def self.call(...)
      new(...).call
    end

    def initialize(total_income:, total_expenditure:)
      @total_income = total_income
      @total_expenditure = total_expenditure
    end

    def call
      raise NotImplementedError
    end

    private

    attr_reader :total_income, :total_expenditure

    def no_income_and_expenditure_records?
      total_income.zero? && total_expenditure.zero?
    end

  end
end
