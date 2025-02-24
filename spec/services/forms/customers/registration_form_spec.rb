# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::Customers::RegistrationForm, type: :form do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:password_confirmation) }
  it { is_expected.to validate_confirmation_of(:password) }

  describe "#save" do
    context "when the form is valid" do
      it "creates a customer, returns true" do
        form = Forms::Customers::RegistrationForm.new(
          email: "john@doe.com",
          password: "123456",
          password_confirmation: "123456"
        )

        expect do
          expect(form.save).to be(true)
          expect(form.errors).to be_empty
        end.to change(Customer, :count).from(0).to(1)
      end

      it "enqueues a job create statement", :sidekiq_inline do
        form = Forms::Customers::RegistrationForm.new(
          email: "john@doe.com",
          password: "123456",
          password_confirmation: "123456"
        )

        expect { form.save }.to change(Statement, :count).from(0).to(1)
      end
    end

    context "when the form is invalid" do
      it "returns false" do
        form = Forms::Customers::RegistrationForm.new(
          email: "",
          password: "",
          password_confirmation: ""
        )

        expect do
          expect(form.save).to be(false)
          expect(form.errors).not_to be_empty
        end.not_to change(Customer, :count)
      end
    end
  end
end
