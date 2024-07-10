# frozen_string_literal: true

class Expenditure < ApplicationRecord

  EXPENDITURE_CATEGORY_OPTIONS = {
    mortgage: "mortgage",
    utilities: "utilities",
    travel: "travel",
    food: "food",
    loan_repayment: "loan_repayment"
  }.freeze

  belongs_to :customer

  enum category: EXPENDITURE_CATEGORY_OPTIONS

  def self.valid_categories
    EXPENDITURE_CATEGORY_OPTIONS.values
  end

end
