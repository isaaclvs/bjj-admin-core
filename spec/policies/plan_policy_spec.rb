require "rails_helper"

RSpec.describe PlanPolicy, type: :policy do
  let(:academy) { create(:academy) }
  let(:owner)   { create(:user, academy: academy, role: :owner) }
  let(:teacher) { create(:user, academy: academy, role: :teacher) }
  let(:plan)    { create(:plan, academy: academy) }

  describe "owner permissions" do
    subject { described_class.new(owner, plan) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  describe "teacher permissions" do
    subject { described_class.new(teacher, plan) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
