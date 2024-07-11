# frozen_string_literal: true

module Customers
  class CreateStatementJob < BaseJob

    def perform(customer_id)
      form = Forms::Customers::CreateStatementForm.new(customer_id: customer_id)

      form.save
    end

  end
end
