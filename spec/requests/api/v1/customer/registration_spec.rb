# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Customer::Registration", type: :request do
  describe "POST /api/v1/customer/registration" do
    context "with valid parameters" do
      let(:customer_params) do
        {
          registration: {
            email: "name@mail.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }
      end

      it "customer can register, a new statement record", :sidekiq_inline do
        expect do
          post(
            "/api/v1/customer/registration",
            params: customer_params
          )
        end.to change(Customer, :count)
          .by(1)
          .and change(Statement, :all)
          .from([])
          .to(
            a_collection_including(
              an_object_having_attributes(
                customer: an_object_having_attributes(
                  email: "name@mail.com"
                ),
                ie_rating: "not_calculated",
                disposable_income_amount: nil
              )
            )
          )

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to eq(
          { "message" => "Customer registered successfully" }
        )
      end
    end

    context "with invalid parameters" do
      let(:customer_params) do
        {
          registration: { email: "", password: "", password_confirmation: "" }
        }
      end

      it "returns 422 unprocessable entity" do
        post(
          "/api/v1/customer/registration",
          params: customer_params
        )

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq(
          {
            "errors" => [
              "Email can't be blank",
              "Password can't be blank",
              "Password confirmation can't be blank"
            ]
          }
        )
      end

      context "when password confirmation is missing" do
        let(:customer_params) do
          {
            registration: {
              email: "name@mail.com",
              password: "123456"
            }
          }
        end

        it "returns 422 unprocessable entity" do
          post(
            "/api/v1/customer/registration",
            params: customer_params
          )

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq(
            { "errors" => ["Password confirmation can't be blank"] }
          )
        end
      end

      context "when password confirmation invalid" do
        let(:customer_params) do
          {
            registration: {
              email: "name@mail.com",
              password: "123456",
              password_confirmation: "222222"
            }
          }
        end

        it "returns 422 unprocessable entity" do
          post(
            "/api/v1/customer/registration",
            params: customer_params
          )

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq(
            { "errors" => ["Password confirmation doesn't match Password"] }
          )
        end
      end
    end
  end
end
