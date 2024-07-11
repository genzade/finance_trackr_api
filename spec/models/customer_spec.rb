# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer, type: :model do
  it { is_expected.to have_secure_password }

  it { is_expected.to have_many(:incomes).dependent(:destroy) }
  it { is_expected.to have_many(:expenditures).dependent(:destroy) }
  it { is_expected.to have_one(:statement).dependent(:destroy) }
end
