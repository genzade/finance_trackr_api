# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Customer::Authentication", type: :request do
  describe "POST /api/v1/customer/authenticate" do
    context "with valid parameters" do
      it "customer can authenticate successfully" do
        customer = create(:customer)
        authenticate_params = {
          customer: {
            email: customer.email,
            password: customer.password
          }
        }

        post(
          "/api/v1/customer/authenticate",
          params: authenticate_params
        )

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to match(
          a_hash_including(
            "message" => "Customer authenticated successfully",
            "data" => a_hash_including(
              "customer_id" => customer.id,
              "token" => be_an(String)
            )
          )
        )
      end
    end

    context "with invalid parameters" do
      context "when email is blank" do
        it "returns 422 unprocessable entity" do
          authenticate_params = {
            customer: {
              password: "123456"
            }
          }

          post(
            "/api/v1/customer/authenticate",
            params: authenticate_params
          )

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq(
            { "errors" => "param is missing or the value is empty: email" }
          )
        end
      end

      context "when password is blank" do
        it "returns 422 unprocessable entity" do
          authenticate_params = {
            customer: {
              email: "name@mail.com"
            }
          }

          post(
            "/api/v1/customer/authenticate",
            params: authenticate_params
          )

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq(
            { "errors" => "param is missing or the value is empty: password" }
          )
        end
      end
    end

    context "when customer is not found" do
      it "returns 401 unauthorized" do
        authenticate_params = {
          customer: {
            email: "name@mail.com",
            password: "123456"
          }
        }

        post(
          "/api/v1/customer/authenticate",
          params: authenticate_params
        )

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body).to eq(
          { "errors" => "Customer record not found" }
        )
      end
    end
  end
end
