# frozen_string_literal: true

module Forms
  module Customers
    class CreateIncomeForm

      include ActiveModel::Model

      attr_accessor :customer_id, :source, :amount

      validates :customer_id, presence: true
      validates(
        :source,
        presence: true,
        inclusion: {
          in: Income.valid_sources,
          message: "must be one of: #{Income.valid_sources.join(', ')}"
        }
      )
      validates :amount, presence: true, numericality: { greater_than: 0 }

      def initialize(customer_id: nil, params: {})
        @customer_id = customer_id

        super(params)
      end

      def save
        return false unless valid?

        income.save

        update_statement_job

        true
      end

      private

      def income
        @income ||= Income.new(
          customer: customer,
          source: source,
          amount: amount
        )
      end

      def customer
        @customer ||= Customer.find_by(id: customer_id)
      end

      def update_statement_job
        ::Customers::UpdateStatementJob.perform_async(customer_id)
      end

    end
  end
end
