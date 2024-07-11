# frozen_string_literal: true

FactoryBot.define do
  factory :expenditure do
    customer { nil }
    amount { 9.99 }
    category { Expenditure.categories[:mortgage] }
  end
end
