# frozen_string_literal: true

module Auths
  class CustomerAuthentication

    def self.call(...)
      new(...).call
    end

    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def call
      return unless customer&.authenticate(password)

      {
        customer_id: customer.id,
        token: token
      }
    end

    private

    attr_reader :email, :password

    def customer
      @customer ||= Customer.find_by(email: email)
    end

    def token
      payload = { resource_id: customer.id, resource_type: :customer }

      Auths::JsonWebToken.encode(payload)
    end

  end
end
