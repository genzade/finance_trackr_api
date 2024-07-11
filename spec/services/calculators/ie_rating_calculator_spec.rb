# frozen_string_literal: true

require "rails_helper"

RSpec.describe Calculators::IeRatingCalculator, type: :service do
  describe "#call" do
    let(:customer) { create(:customer) }

    context "when customer has no income or expenditure records" do
      it "returns not_calculated" do
        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("not_calculated")
      end
    end

    context "when customer only has expenditure records" do
      it "returns correct amount" do
        create(:expenditure, amount: 40.0, customer: customer)

        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("not_calculated")
      end
    end

    context "when customer only has income records" do
      it "returns not_calculated" do
        create(:income, customer: customer)

        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("a")
      end
    end

    context "when customer only has both income and expenditure records" do
      it "returns correct amount for ratio is 4:1" do
        create(:expenditure, amount: 40.0, customer: customer)
        create(:income, amount: 10.0, customer: customer)

        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("d")
      end

      it "returns correct amount for ratio is 1:1" do
        create(:expenditure, amount: 10.0, customer: customer)
        create(:income, amount: 10.0, customer: customer)

        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("d")
      end

      it "returns correct amount for ratio is 1:2" do
        create(:expenditure, amount: 10.0, customer: customer)
        create(:income, amount: 20.0, customer: customer)

        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("c")
      end

      it "returns correct amount for ratio is 1:3" do
        create(:expenditure, amount: 10.0, customer: customer)
        create(:income, amount: 30.0, customer: customer)

        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("c")
      end

      it "returns correct amount for ratio is 1:4" do
        create(:expenditure, amount: 10.0, customer: customer)
        create(:income, amount: 40.0, customer: customer)

        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("b")
      end

      it "returns correct amount for ratio is 1:10" do
        create(:expenditure, amount: 10.0, customer: customer)
        create(:income, amount: 100.0, customer: customer)

        calculator = Calculators::IeRatingCalculator.new(customer)

        expect(calculator.call).to eq("a")
      end
    end
  end
end
