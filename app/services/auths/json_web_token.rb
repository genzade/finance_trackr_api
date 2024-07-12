# frozen_string_literal: true

module Auths
  class JsonWebToken

    # IMPORTANT:
    # For the purposes of this exercise this HMAC_SECRET_KEY is left exposed like this.
    # This would absolutely not be the way to go if this application was intended
    # to be deployed to production. The HMAC_SECRET_KEY would be hidden away in an `env`
    # var or locked away using `Rails.credentials`
    HMAC_SECRET_KEY = "My5up3rD4pp3r$ecretK3y"
    ALGORITHM = "HS256"

    def self.encode(payload, exp = 2.hours.from_now)
      payload[:exp] = exp.to_i

      JWT.encode(payload, HMAC_SECRET_KEY, ALGORITHM)
    end

    def self.decode(token)
      body = JWT.decode(token, HMAC_SECRET_KEY)[0]

      ActiveSupport::HashWithIndifferentAccess.new(body)
    end

  end
end
