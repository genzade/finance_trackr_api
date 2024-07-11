# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Customers::Statement", type: :request do
  let(:customer) { create(:customer, :with_statement) }

  describe "GET /api/v1/customers/:customer_id/statement" do
    context "when customer has no income or expenditure records" do
      it "returns http ok" do
        get "/api/v1/customers/#{customer.id}/statement", as: :json

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
          params: { expenditure: { category: "mortgage", amount: 500.0 } }
        )
        post(
          "/api/v1/customers/#{customer.id}/income",
          params: { income: { source: "salary", amount: 2800.0 } }
        )
      end

      it "returns http ok", :sidekiq_inline do
        get "/api/v1/customers/#{customer.id}/statement"

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
    end
  end
end
