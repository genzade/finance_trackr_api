# frozen_string_literal: true

FactoryBot.define do
  factory :income do
    customer { nil }
    amount { 9.99 }
    source { Income.sources[:salary] }
  end
end
