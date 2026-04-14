require "rails_helper"

RSpec.describe Plan, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:academy) }
    it { is_expected.to have_many(:enrollments).dependent(:restrict_with_error) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:price_cents).is_greater_than(0) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:interval).with_values(monthly: 0, quarterly: 1, semiannual: 2) }
  end

  describe "scopes" do
    let(:academy) { create(:academy) }

    describe ".active" do
      it "returns only active plans" do
        active_plan   = create(:plan, academy: academy, active: true)
        inactive_plan = create(:plan, academy: academy, active: false)
        expect(Plan.active).to include(active_plan)
        expect(Plan.active).not_to include(inactive_plan)
      end
    end
  end

  describe "#price" do
    it "converts price_cents to BRL" do
      plan = build(:plan, price_cents: 15000)
      expect(plan.price).to eq(150.0)
    end
  end
end
