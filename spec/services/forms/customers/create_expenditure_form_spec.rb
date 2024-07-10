# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::Customers::CreateExpenditureForm, type: :form do
  it { is_expected.to validate_presence_of(:customer_id) }
  it { is_expected.to validate_presence_of(:category) }

  it do
    is_expected.to validate_inclusion_of(:category)
      .in_array(Expenditure.valid_categories)
      .with_message("must be one of: #{Expenditure.valid_categories.join(', ')}")
  end

  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

  describe "#save" do
    context "when the form is valid" do
      it "creates a customer expenditure, returns true" do
        customer = create(:customer)
        form = Forms::Customers::CreateExpenditureForm.new(
          customer_id: customer.id,
          params: { category: "mortgage", amount: 500.0 }
        )

        expect do
          expect(form.save).to be(true)
          expect(form.errors).to be_empty
        end.to change(Expenditure, :last)
          .from(nil)
          .to(
            an_object_having_attributes(
              customer: customer,
              category: "mortgage",
              amount: 500.0
            )
          )
      end
    end

    context "when the form is invalid" do
      it "returns false" do
        customer = create(:customer)
        form = Forms::Customers::CreateExpenditureForm.new(
          customer_id: customer.id,
          params: { category: :foo }
        )

        expect do
          expect(form.save).to be(false)
          expect(form.errors.full_messages).to include(
            "Category must be one of: #{Expenditure.valid_categories.join(', ')}",
            "Amount can't be blank",
            "Amount is not a number"
          )
        end.not_to change(Expenditure, :count)
      end
    end
  end
end
