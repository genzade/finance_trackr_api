# frozen_string_literal: true

require "rails_helper"

RSpec.describe Expenditure, type: :model do
  subject { build(:expenditure) }

  it { is_expected.to belong_to(:customer) }

  it do
    is_expected.to define_enum_for(:category)
      .with_values(Expenditure::EXPENDITURE_CATEGORY_OPTIONS)
      .backed_by_column_of_type(:string)
  end
end
