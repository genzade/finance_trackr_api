# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::Customers::CreateStatementForm, type: :form do
  it { is_expected.to validate_presence_of(:customer_id) }

  describe "#save" do
    context "when the form is valid" do
      context "when customer has no statement" do
        it "creates a customer, returns true" do
          customer = create(:customer)
          form = Forms::Customers::CreateStatementForm.new(
            customer_id: customer.id,
            params: {}
          )

          expect do
            expect(form.save).to be(true)
            expect(form.errors.full_messages).to be_empty
          end.to change(Statement, :all)
            .from([])
            .to(
              a_collection_containing_exactly(
                an_object_having_attributes(
                  customer: customer,
                  ie_rating: Statement.ie_ratings[:not_calculated],
                  disposable_income_amount: nil
                )
              )

            )
        end
      end

      context "when customer already has statement" do
        it "returns false, does not create a statement" do
          customer = create(:customer, :with_statement)
          form = Forms::Customers::CreateStatementForm.new(
            customer_id: customer.id,
            params: {}
          )

          expect do
            expect(form.save).to be(false)
            expect(form.errors.full_messages).to include(
              "Customer already has a statement"
            )
          end.not_to change(Statement, :count)
        end
      end
    end

    context "when the form is invalid" do
      it "returns false" do
        form = Forms::Customers::CreateStatementForm.new(
          customer_id: nil,
          params: {}
        )

        expect do
          expect(form.save).to be(false)
          expect(form.errors.full_messages).to include(
            "Customer can't be blank"
          )
        end.not_to change(Statement, :count)
      end
    end
  end
end
