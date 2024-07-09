# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    email { "john@doe.com" }
    password { "Password" }
  end
end
