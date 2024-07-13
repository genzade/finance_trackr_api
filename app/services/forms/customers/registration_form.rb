# frozen_string_literal: true

module Forms
  module Customers
    class RegistrationForm

      include ActiveModel::Model

      attr_accessor :email, :password, :password_confirmation

      validates :email, presence: true
      validates :password, presence: true, confirmation: true
      validates :password_confirmation, presence: true

      def save
        return false unless valid?

        customer.save

        create_statement_job

        true
      end

      private

      def customer
        @customer ||= Customer.new(
          email: email,
          password: password,
          password_confirmation: password_confirmation
        )
      end

      def create_statement_job
        ::Customers::CreateStatementJob.perform_async(customer.id)
      end

    end
  end
end
