# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::Customers::CreateIncomeForm, type: :form do
  it { is_expected.to validate_presence_of(:customer_id) }
  it { is_expected.to validate_presence_of(:source) }

  it do
    is_expected.to validate_inclusion_of(:source)
      .in_array(Income.valid_sources)
      .with_message("must be one of: #{Income.valid_sources.join(', ')}")
  end

  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

  describe "#save" do
    context "when the form is valid" do
      it "creates a customer income, returns true" do
        customer = create(:customer)
        form = Forms::Customers::CreateIncomeForm.new(
          customer_id: customer.id,
          params: { source: "salary", amount: 2800.0 }
        )

        expect do
          expect(form.save).to be(true)
          expect(form.errors).to be_empty
        end.to change(Income, :last)
          .from(nil)
          .to(
            an_object_having_attributes(
              customer: customer,
              source: "salary",
              amount: 2800.0
            )
          )
          .and enqueue_sidekiq_job(Customers::UpdateStatementJob)
          .with(customer.id)
      end
    end

    context "when the form is invalid" do
      it "returns false" do
        customer = create(:customer)
        form = Forms::Customers::CreateIncomeForm.new(
          customer_id: customer.id,
          params: { source: :foo }
        )

        expect do
          expect(form.save).to be(false)
          expect(form.errors.full_messages).to include(
            "Source must be one of: salary, other",
            "Amount can't be blank",
            "Amount is not a number"
          )
        end.not_to change(Income, :count)
      end
    end
  end
end
