require "rails_helper"

RSpec.describe HealthRecordPolicy, type: :policy do
  let(:academy)       { create(:academy) }
  let(:owner)         { create(:user, academy: academy, role: :owner) }
  let(:teacher)       { create(:user, academy: academy, role: :teacher) }
  let(:student)       { create(:student, academy: academy) }
  let(:health_record) { create(:health_record, student: student) }

  describe "owner permissions" do
    subject { described_class.new(owner, health_record) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  describe "teacher permissions" do
    subject { described_class.new(teacher, health_record) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
