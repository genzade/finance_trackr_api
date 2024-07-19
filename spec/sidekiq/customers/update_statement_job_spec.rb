# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customers::UpdateStatementJob, type: :job do
  let(:customer_id) { 123 }

  it "enqueues itself on default queue" do
    expect { Customers::UpdateStatementJob.perform_async(customer_id) }
      .to enqueue_sidekiq_job(Customers::UpdateStatementJob)
      .with(customer_id)
      .on("default")
  end

  it "calculates statement disposable income for the customer", :sidekiq_inline do
    customer = create(:customer, :with_statement)
    di_calculator_klass = Calculators::DisposableIncomeCalculator
    stubbed_di_calculator = instance_double(di_calculator_klass, call: 100.0)

    allow(di_calculator_klass).to receive(:new)
      .with(total_income: 0.0, total_expenditure: 0.0)
      .and_return(stubbed_di_calculator)

    Customers::UpdateStatementJob.perform_async(customer.id)

    expect(stubbed_di_calculator).to have_received(:call)
  end

  it "calculates statement ie_rating for the customer", :sidekiq_inline do
    customer = create(:customer, :with_statement)
    ier_calculator_klass = Calculators::IeRatingCalculator
    stubbed_ier_calculator = instance_double(ier_calculator_klass, call: "not_calculated")

    allow(ier_calculator_klass).to receive(:new)
      .with(total_income: 0.0, total_expenditure: 0.0)
      .and_return(stubbed_ier_calculator)

    Customers::UpdateStatementJob.perform_async(customer.id)

    expect(stubbed_ier_calculator).to have_received(:call)
  end
end
