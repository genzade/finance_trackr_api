# frozen_string_literal: true

class Income < ApplicationRecord

  INCOME_SOURCE_OPTIONS = {
    salary: "salary",
    other: "other"
  }.freeze

  belongs_to :customer

  enum source: INCOME_SOURCE_OPTIONS

  def self.valid_sources
    INCOME_SOURCE_OPTIONS.values
  end

end
