require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "validations" do
    subject { build(:customer) } # Uses a factory to avoid duplication

    it "is valid with all attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a user" do
      subject.user = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without a name" do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without an email" do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without an external_id" do
      subject.external_id = nil
      expect(subject).not_to be_valid
    end

    it "is invalid with a duplicate email" do
      create(:customer, email: subject.email)
      expect(subject).not_to be_valid
    end

    it "is invalid with a duplicate external_id" do
      create(:customer, external_id: subject.external_id)
      expect(subject).not_to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:payments).dependent(:destroy) }
    it { should have_one(:card).dependent(:destroy) }
  end
end
