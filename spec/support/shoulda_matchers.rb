# frozen_string_literal: true

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveModel, type: :form)
  config.include(Shoulda::Matchers::ActiveRecord, type: :form)
end
