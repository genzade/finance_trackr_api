# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auths::JsonWebToken, type: :service do
  let(:hmac_secret) { "some_key" }

  before do
    stub_const("Auths::JsonWebToken::HMAC_SECRET_KEY", hmac_secret)
  end

  context "when encoding and decoding payload" do
    it "returns an encoded jwt token" do
      default_exp = 2.hours.from_now
      jwt = Auths::JsonWebToken.encode({ user_id: 1 })
      decoded_jwt = JWT.decode(jwt, hmac_secret, true, algorithm: "HS256")

      expect(decoded_jwt[0]["user_id"]).to eq(1)
      expect(decoded_jwt[0]["exp"]).to eq(default_exp.to_i)
    end

    it "returns an encoded jwt token with a custom expiration time" do
      exp = 1.day.from_now
      jwt = Auths::JsonWebToken.encode({ user_id: 1 }, exp)
      decoded_jwt = JWT.decode(jwt, hmac_secret, true, algorithm: "HS256")

      expect(decoded_jwt[0]["user_id"]).to eq(1)
      expect(decoded_jwt[0]["exp"]).to eq(exp.to_i)
    end
  end
end
