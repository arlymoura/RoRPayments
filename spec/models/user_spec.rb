require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validações" do
    it "é válido com nome, email e senha" do
      expect(user).to be_valid
    end

    it "é inválido sem um nome" do
      user.name = nil
      expect(user).not_to be_valid
    end

    it "é inválido sem um email" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "é inválido com um email duplicado" do
      create(:user, email: user.email)
      expect(user).not_to be_valid
    end

    it "é inválido sem uma senha" do
      user.password = nil
      expect(user).not_to be_valid
    end

    it "é inválido se a senha for muito curta" do
      user.password = "12345"
      user.password_confirmation = "12345"
      expect(user).not_to be_valid
    end
  end

  describe "associações" do
    it { should have_many(:customers) } # Exemplo de associação caso exista
  end
end
