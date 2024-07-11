# frozen_string_literal: true

class Statement < ApplicationRecord

  IE_RATING_OPTIONS = {
    not_calculated: "not_calculated",
    rated_A: "rated_A",
    rated_B: "rated_B",
    rated_C: "rated_C",
    rated_D: "rated_D"
  }.freeze

  belongs_to :customer

  enum ie_rating: IE_RATING_OPTIONS

end
