# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::Customers::UpdateStatementForm, type: :service do
  describe "#save" do
    it "updates the statement ie_rating and disposable_income_amount" do
      customer = create(:customer)
      statement = create(:statement, customer: customer)
      total_income_amount = 100.0
      total_expenditure_amount = 50.0
      form = Forms::Customers::UpdateStatementForm.new(statement: statement)

      allow(form).to receive_messages(
        total_income_amount: total_income_amount,
        total_expenditure_amount: total_expenditure_amount
      )

      expect { form.save }
        .to change { statement.reload.ie_rating }
        .from("not_calculated").to("rated_C")
        .and change { statement.reload.disposable_income_amount }
        .from(9.99)
        .to(total_expenditure_amount)
    end

    it "call the disposable income calculator" do
      customer = create(:customer)
      statement = create(:statement, customer: customer)
      form = Forms::Customers::UpdateStatementForm.new(statement: statement)

      allow(form).to receive_messages(
        total_income_amount: 100.0,
        total_expenditure_amount: 50.0
      )

      di_calculator_klass = Calculators::DisposableIncomeCalculator
      stubbed_di_calculator = instance_double(di_calculator_klass, call: 100.0)

      allow(di_calculator_klass).to receive(:new)
        .with(
          total_income: 100.0,
          total_expenditure: 50.0
        ).and_return(stubbed_di_calculator)

      form.save

      expect(stubbed_di_calculator).to have_received(:call)
    end

    it "call the ie_rating calculator" do
      customer = create(:customer)
      statement = create(:statement, customer: customer)
      form = Forms::Customers::UpdateStatementForm.new(statement: statement)

      allow(form).to receive_messages(
        total_income_amount: 100.0,
        total_expenditure_amount: 50.0
      )

      ier_calculator_klass = Calculators::IeRatingCalculator
      stubbed_ier_calculator = instance_double(ier_calculator_klass, call: "not_calculated")

      allow(ier_calculator_klass).to receive(:new)
        .with(
          total_income: 100.0,
          total_expenditure: 50.0
        ).and_return(stubbed_ier_calculator)

      form.save

      expect(stubbed_ier_calculator).to have_received(:call)
    end
  end
end
