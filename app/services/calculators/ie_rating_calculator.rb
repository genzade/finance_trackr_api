# frozen_string_literal: true

module Calculators
  class IeRatingCalculator

    def initialize(customer)
      @customer = customer
    end

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

    attr_reader :customer

    delegate :incomes, :expenditures, to: :customer

    def ratio
      total_expenditure_amount / total_income_amount.to_f
    end

    def not_calculatable?
      no_income_and_expenditure_records? || incomes.empty?
    end

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
