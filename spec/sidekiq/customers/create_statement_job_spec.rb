# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customers::CreateStatementJob, type: :job do
  let(:customer_id) { 123 }

  it "enqueues itself on default queue" do
    expect { Customers::CreateStatementJob.perform_async(customer_id) }
      .to enqueue_sidekiq_job(Customers::CreateStatementJob)
      .with(customer_id)
      .on("default")
  end

  it "creates a statement for the customer", :sidekiq_inline do
    form_klass = Forms::Customers::CreateStatementForm
    stubbed_form = instance_double(form_klass, save: true)

    allow(form_klass).to receive(:new)
      .with(customer_id: customer_id)
      .and_return(stubbed_form)

    Customers::CreateStatementJob.perform_async(customer_id)

    expect(stubbed_form).to have_received(:save)
  end
end
