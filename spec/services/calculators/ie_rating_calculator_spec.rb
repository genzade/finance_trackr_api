# frozen_string_literal: true

require "rails_helper"

RSpec.describe Calculators::IeRatingCalculator, type: :service do
  describe "#call" do
    let(:customer) { create(:customer) }

    context "when customer has no income or expenditure records" do
      it "returns not_calculated" do
        calculator = Calculators::IeRatingCalculator.new(
          total_income: 0.0,
          total_expenditure: 0.0
        )

        expect(calculator.call).to eq("not_calculated")
      end
    end

    context "when customer only has expenditure records" do
      it "returns correct amount" do
        calculator = Calculators::IeRatingCalculator.new(
          total_income: 0.0,
          total_expenditure: 40.0
        )

        expect(calculator.call).to eq("not_calculated")
      end
    end

    context "when customer only has income records" do
      it "returns rated A" do
        calculator = Calculators::IeRatingCalculator.new(
          total_income: 10.0,
          total_expenditure: 0.0
        )

        expect(calculator.call).to eq("rated_A")
      end
    end

    context "when customer only has both income and expenditure records" do
      it "returns correct amount for ratio greater than 0.5" do
        calculator = Calculators::IeRatingCalculator.new(
          total_income: 10.0,
          total_expenditure: 10.0
        )

        expect(calculator.call).to eq("rated_D")
      end

      it "returns correct amount for ratio less than 0.5" do
        calculator = Calculators::IeRatingCalculator.new(
          total_income: 30.0,
          total_expenditure: 10.0
        )

        expect(calculator.call).to eq("rated_C")
      end

      it "returns correct amount for ratio less than 0.3" do
        calculator = Calculators::IeRatingCalculator.new(
          total_income: 40.0,
          total_expenditure: 10.0
        )

        expect(calculator.call).to eq("rated_B")
      end

      it "returns correct amount for ratio less than 0.1" do
        calculator = Calculators::IeRatingCalculator.new(
          total_income: 100.0,
          total_expenditure: 10.0
        )

        expect(calculator.call).to eq("rated_A")
      end
    end
  end
end
