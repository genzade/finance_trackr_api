# frozen_string_literal: true

module Forms
  module Customers
    class CreateExpenditureForm

      include ActiveModel::Model

      attr_accessor :customer_id, :category, :amount

      validates :customer_id, presence: true
      validates(
        :category,
        presence: true,
        inclusion: {
          in: Expenditure.valid_categories,
          message: "must be one of: #{Expenditure.valid_categories.join(', ')}"
        }
      )
      validates :amount, presence: true, numericality: { greater_than: 0 }

      def initialize(customer_id: nil, params: {})
        @customer_id = customer_id

        super(params)
      end

      def save
        return false unless valid?

        expenditure.save

        update_statement_job

        true
      end

      private

      def expenditure
        @expenditure ||= Expenditure.new(
          customer: customer,
          category: category,
          amount: amount
        )
      end

      def customer
        @customer ||= Customer.find_by(id: customer_id)
      end

      def update_statement_job
        ::Customers::UpdateStatementJob.perform_async(customer.id)
      end

    end
  end
end
