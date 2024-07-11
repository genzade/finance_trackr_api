# frozen_string_literal: true

module Calculators
  class IeRatingCalculator < Calculators::BaseCalculator

    def call
      return Statement.ie_ratings[:not_calculated] if not_calculatable?

      case ratio
      when 0..0.1
        Statement.ie_ratings[:rated_A]
      when 0.11..0.30
        Statement.ie_ratings[:rated_B]
      when 0.31..0.50
        Statement.ie_ratings[:rated_C]
      else
        Statement.ie_ratings[:rated_D]
      end
    end

    private

    def ratio
      total_expenditure_amount / total_income_amount.to_f
    end

    def not_calculatable?
      no_income_and_expenditure_records? || incomes.empty?
    end

  end
end
