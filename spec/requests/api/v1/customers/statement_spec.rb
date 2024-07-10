# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Customers::Statement", type: :request do
  let(:income) { create(:income, source: :salary, amount: 2800.0, customer: customer) }
  let(:expenditure) { create(:expenditure, category: :mortgage, amount: 500.0, customer: customer) }
  let(:customer) { create(:customer) }

  describe "GET /api/v1/customers/:customer_id/statement" do
    context "when customer has income and expenditure records" do
      before do
        income
        expenditure
      end

      it "returns http ok" do
        get "/api/v1/customers/#{customer.id}/statements"

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(
          {
            "message" => "Statement created successfully",
            "data" => {
              "income" => [
                { "source" => "Salary", "amount" => 2800.0 }
              ],
              "expenditure" => [
                { "category" => "Mortgage", "amount" => 500.0 }
              ],
              "ie_rating" => "B",
              "disposable_income" => 2300.0
            }
          }
        )
      end
    end
  end
end
