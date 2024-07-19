# frozen_string_literal: true

require "rails_helper"

RSpec.describe Calculators::DisposableIncomeCalculator, type: :service do
  describe "#call" do
    context "when customer has no income or expenditure records" do
      it "returns nil" do
        calculator = Calculators::DisposableIncomeCalculator.new(
          total_income: 0.0,
          total_expenditure: 0.0
        )

        expect(calculator.call).to be_nil
      end
    end

    context "when customer only has income records" do
      it "returns correct amount" do
        calculator = Calculators::DisposableIncomeCalculator.new(
          total_income: 10.0,
          total_expenditure: 0.0
        )

        expect(calculator.call).to eq(10.0)
      end
    end

    context "when customer only has expenditure records" do
      it "returns correct amount" do
        calculator = Calculators::DisposableIncomeCalculator.new(
          total_income: 0.0,
          total_expenditure: 40.0
        )

        expect(calculator.call).to eq(-40.0)
      end
    end

    context "when customer only has both income and expenditure records" do
      it "returns correct amount" do
        calculator = Calculators::DisposableIncomeCalculator.new(
          total_income: 10.0,
          total_expenditure: 40.0
        )

        expect(calculator.call).to eq(-30.0)
      end
    end
  end
end
