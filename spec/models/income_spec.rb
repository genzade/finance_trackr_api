# frozen_string_literal: true

require "rails_helper"

RSpec.describe Income, type: :model do
  it { is_expected.to belong_to(:customer) }

  it do
    is_expected.to define_enum_for(:source)
      .with_values(Income::INCOME_SOURCE_OPTIONS)
      .backed_by_column_of_type(:string)
  end
end
