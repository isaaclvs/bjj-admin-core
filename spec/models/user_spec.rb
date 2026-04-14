require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:academy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:role) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:role).with_values(owner: 0, teacher: 1) }
  end

  describe "#owner?" do
    it "returns true for owner role" do
      user = build(:user, role: :owner)
      expect(user.owner?).to be true
    end

    it "returns false for teacher role" do
      user = build(:user, role: :teacher)
      expect(user.owner?).to be false
    end
  end
end
