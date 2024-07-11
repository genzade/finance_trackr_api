# frozen_string_literal: true

require "rails_helper"

RSpec.describe Calculators::DisposableIncomeCalculator, type: :service do
  describe "#call" do
    context "when customer has no income or expenditure records" do
      it "returns nil" do
        customer = build(:customer)

        calculator = Calculators::DisposableIncomeCalculator.new(customer)

        expect(calculator.call).to be_nil
      end
    end

    context "when customer only has income records" do
      it "returns correct amount" do
        customer = create(:customer)

        create(:income, amount: 10.0, customer: customer)

        calculator = Calculators::DisposableIncomeCalculator.new(customer)

        expect(calculator.call).to eq(10.0)
      end
    end

    context "when customer only has expenditure records" do
      it "returns correct amount" do
        customer = create(:customer)

        create(:expenditure, amount: 40.0, customer: customer)

        calculator = Calculators::DisposableIncomeCalculator.new(customer)

        expect(calculator.call).to eq(-40.0)
      end
    end

    context "when customer only has both income and expenditure records" do
      it "returns correct amount" do
        customer = create(:customer)

        create(:income, amount: 10.0, customer: customer)
        create(:expenditure, amount: 40.0, customer: customer)

        calculator = Calculators::DisposableIncomeCalculator.new(customer)

        expect(calculator.call).to eq(-30.0)
      end
    end
  end
end
