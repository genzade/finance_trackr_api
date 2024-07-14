# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auths::CustomerAuthentication, type: :service do
  describe "#call" do
    context "when customer exists" do
      let(:customer) { build_stubbed(:customer) }

      before do
        allow(Customer).to receive(:find_by)
          .with(email: customer.email)
          .and_return(customer)
      end

      context "when password is correct" do
        it "returns a hash with customer id and token" do
          authentication = Auths::CustomerAuthentication.new(
            email: customer.email,
            password: customer.password
          )

          expect(authentication.call).to match(
            a_hash_including(
              customer_id: customer.id,
              token: be_an(String)
            )
          )
        end
      end

      context "when password is incorrect" do
        it "returns nil" do
          authentication = Auths::CustomerAuthentication.new(
            email: customer.email,
            password: "incorrect_password"
          )

          expect(authentication.call).to be_nil
        end
      end
    end

    context "when customer does not exists" do
      it "returns nil" do
        authentication = Auths::CustomerAuthentication.new(
          email: "foo@bar.com",
          password: "password"
        )

        expect(authentication.call).to be_nil
      end
    end
  end
end
