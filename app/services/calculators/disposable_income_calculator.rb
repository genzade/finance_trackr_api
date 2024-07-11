# frozen_string_literal: true

module Calculators
  class DisposableIncomeCalculator < Calculators::BaseCalculator

    def call
      return nil if no_income_and_expenditure_records?

      total_income_amount - total_expenditure_amount
    end

  end
end
