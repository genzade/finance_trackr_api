# frozen_string_literal: true

module Calculators
  class IeRatingCalculator < Calculators::BaseCalculator

    def call
      Statement.ie_ratings[rating]
    end

    private

    def ratio
      total_expenditure / total_income
    end

    def not_calculatable?
      no_income_and_expenditure_records? || total_income.zero?
    end

    def rating
      return :not_calculated if not_calculatable?
      return :rated_A if ratio <= 0.1
      return :rated_B if ratio <= 0.3
      return :rated_C if ratio <= 0.5

      :rated_D
    end

  end
end
