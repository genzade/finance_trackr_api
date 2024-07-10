# frozen_string_literal: true

class Customer < ApplicationRecord

  has_secure_password

  with_options dependent: :destroy do
    has_many :incomes
    has_many :expenditures
  end

end
