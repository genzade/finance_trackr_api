# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Customer::Registration", type: :request do
  describe "POST /api/v1/customer/registration" do
    context "with valid parameters" do
      let(:customer_params) do
        {
          email: "name@mail.com",
          password: "123456",
          password_confirmation: "123456"
        }
      end

      it "customer can register" do
        expect do
          post(
            "/api/v1/customer/registration",
            params: customer_params
          )
        end.to change(Customer, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(
          { "message" => "Customer registered successfully" }
        )
      end
    end

    context "with invalid parameters" do
      let(:customer_params) do
        { email: "", password: "", password_confirmation: "" }
      end

      it "returns 422 unprocessable entity" do
        post(
          "/api/v1/customer/registration",
          params: customer_params
        )
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
