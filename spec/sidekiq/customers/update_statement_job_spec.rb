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
    form_klass = Forms::Customers::UpdateStatementForm
    stubbed_form = instance_double(form_klass, save: true)
    allow(form_klass).to receive(:new)
      .with(statement: customer.statement)
      .and_return(stubbed_form)

    Customers::UpdateStatementJob.perform_async(customer.id)

    expect(stubbed_form).to have_received(:save)
  end
end
