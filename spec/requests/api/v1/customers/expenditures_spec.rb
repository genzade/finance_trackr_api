# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Customers::Expenditures", type: :request do
  let(:customer) { create(:customer) }
  let(:token) do
    Auths::JsonWebToken.encode(resource_type: "Customer", resource_id: customer.id)
  end
  let(:headers) do
    { "Authorization" => "Bearer #{token}" }
  end

  describe "POST /api/v1/customers/expenditures" do
    context "with valid parameters" do
      it "creates a customer expenditure record" do
        post(
          "/api/v1/customers/#{customer.id}/expenditure",
          params: { expenditure: { category: "mortgage", amount: 500.0 } },
          headers: headers
        )

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to eq(
          { "message" => "Expenditure created successfully" }
        )
      end
    end

    context "with invalid parameters" do
      it "returns 422 unprocessable entity" do
        post(
          "/api/v1/customers/#{customer.id}/expenditure",
          params: { expenditure: { category: "foo" } },
          headers: headers
        )

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq(
          {
            "errors" => [
              "Category must be one of: mortgage, utilities, travel, food, loan_repayment",
              "Amount can't be blank",
              "Amount is not a number"
            ]
          }
        )
      end
    end
  end
end
