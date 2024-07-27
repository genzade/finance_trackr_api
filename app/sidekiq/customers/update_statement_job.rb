# frozen_string_literal: true

module Customers
  class UpdateStatementJob < BaseJob

    def perform(customer_id)
      statement ||= Statement.find_by(customer_id: customer_id)

      update_statement_form = Forms::Customers::UpdateStatementForm.new(statement: statement)
      update_statement_form.save
    end

  end
end
