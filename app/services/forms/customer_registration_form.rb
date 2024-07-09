# frozen_string_literal: true

module Forms
  class CustomerRegistrationForm

    include ActiveModel::Model

    attr_accessor :email, :password, :password_confirmation

    validates :email, presence: true
    validates :password, presence: true, confirmation: true

    def save
      return false unless valid?

      Customer.create!(
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )

      true
    end

  end
end
