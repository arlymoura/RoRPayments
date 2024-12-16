require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject { create(:payment, customer: customer) }

  let(:customer) { create(:customer) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without an external_id" do
    subject.external_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without an amount" do
    subject.amount = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a non-numerical amount" do
    subject.amount = "abc"
    expect(subject).to_not be_valid
  end

  it "is not valid without a status" do
    subject.status = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a payment_method" do
    subject.payment_method = nil
    expect(subject).to_not be_valid
  end

  it "is valid with a unique external_id" do
    payment2 = build(:payment, external_id: subject.external_id)
    expect(payment2).to_not be_valid
  end
end
