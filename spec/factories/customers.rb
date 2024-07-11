# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    email { "john@doe.com" }
    password { "Password" }

    trait :with_statement do
      after(:create) do |customer|
        create(:statement, customer: customer)
      end
    end
  end
end
