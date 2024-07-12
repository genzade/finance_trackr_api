# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Customers::Incomes", type: :request do
  let(:customer) { create(:customer) }
  let(:token) do
    Auths::JsonWebToken.encode(resource_type: "Customer", resource_id: customer.id)
  end
  let(:headers) do
    { "Authorization" => "Bearer #{token}" }
  end

  describe "POST /api/v1/customers/income" do
    context "with valid parameters" do
      it "creates a customer income record" do
        post(
          "/api/v1/customers/#{customer.id}/income",
          params: { income: { source: "salary", amount: 2800.0 } },
          headers: headers
        )

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to eq(
          { "message" => "Income created successfully" }
        )
      end
    end

    context "with invalid parameters" do
      it "returns 422 unprocessable entity" do
        post(
          "/api/v1/customers/#{customer.id}/income",
          params: { income: { source: "foo" } },
          headers: headers
        )

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq(
          {
            "errors" => [
              "Source must be one of: salary, other",
              "Amount can't be blank",
              "Amount is not a number"
            ]
          }
        )
      end
    end
  end
end
