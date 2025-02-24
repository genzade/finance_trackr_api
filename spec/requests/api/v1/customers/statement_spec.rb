# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Customers::Statement", type: :request do
  let(:customer) { create(:customer, :with_statement) }
  let(:token) do
    Auths::JsonWebToken.encode(resource_type: "Customer", resource_id: customer.id)
  end
  let(:headers) do
    { "Authorization" => "Bearer #{token}" }
  end

  describe "GET /api/v1/customers/:customer_id/statement" do
    context "when customer has no income or expenditure records" do
      it "returns http ok" do
        get "/api/v1/customers/#{customer.id}/statement", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(
          {
            "message" => "Statement fetched successfully",
            "data" => {
              "income" => [],
              "expenditure" => [],
              "ie_rating" => "Not Calculated",
              "disposable_income_amount" => "9.99"
            }
          }
        )
      end
    end

    context "when customer has income and expenditure records" do
      before do
        post(
          "/api/v1/customers/#{customer.id}/expenditure",
          params: { expenditure: { category: "mortgage", amount: 500.0 } },
          headers: headers
        )
        post(
          "/api/v1/customers/#{customer.id}/income",
          params: { income: { source: "salary", amount: 2800.0 } },
          headers: headers
        )
      end

      it "returns http ok", :sidekiq_inline do
        get "/api/v1/customers/#{customer.id}/statement", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(
          {
            "message" => "Statement fetched successfully",
            "data" => {
              "income" => [
                { "source" => "salary", "amount" => "2800.0" }
              ],
              "expenditure" => [
                { "category" => "mortgage", "amount" => "500.0" }
              ],
              "ie_rating" => "Rated B",
              "disposable_income_amount" => "2300.0"
            }
          }
        )
      end

      context "when using an expired token" do
        it "returns 401 unauthorized" do
          expired_token = Auths::JsonWebToken.encode(
            resource_type: "Customer",
            resource_id: customer.id
          )
          travel_to 3.hours.from_now do
            get(
              "/api/v1/customers/#{customer.id}/statement",
              headers: { "Authorization" => "Bearer #{expired_token}" }
            )
          end

          expect(response).to have_http_status(:unauthorized)
          expect(response.parsed_body).to eq(
            { "errors" => "Signature has expired" }
          )
        end
      end
    end
  end
end
