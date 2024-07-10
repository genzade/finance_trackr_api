# frozen_string_literal: true

class Statement < ApplicationRecord

  IE_RATING_OPTIONS = {
    not_calculated: "not_calculated",
    rated_a: "a",
    rated_b: "b",
    rated_c: "c",
    rated_d: "d"
  }.freeze

  belongs_to :customer

  enum ie_rating: IE_RATING_OPTIONS

end
