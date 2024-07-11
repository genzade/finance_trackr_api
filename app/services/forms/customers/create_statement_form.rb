# frozen_string_literal: true

module Forms
  module Customers
    class CreateStatementForm

      include ActiveModel::Model

      attr_accessor :customer_id

      validates :customer_id, presence: true

      def initialize(customer_id: nil, params: {})
        @customer_id = customer_id

        super(params)
      end

      def save
        return false unless valid?

        if customer_statement_present?
          errors.add(
            :customer_id,
            I18n.t("customer.statement.errors.messages.already_has_statement")
          )

          return false
        end

        statement.save

        true
      end

      private

      def customer_statement_present?
        Statement.exists?(customer_id: customer_id)
      end

      def customer
        @customer ||= Customer.includes(:statement).find_by(id: customer_id)
      end

      def statement
        @statement ||= Statement.new(customer: customer)
      end

    end
  end
end
