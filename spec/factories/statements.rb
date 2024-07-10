# frozen_string_literal: true

FactoryBot.define do
  factory :statement do
    customer { nil }
    ie_rating { "MyString" }
    disposable_income_amount { "9.99" }
  end
end
