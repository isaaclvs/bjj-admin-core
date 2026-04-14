require "rails_helper"

RSpec.describe Student, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:academy) }
    it { is_expected.to have_one(:health_record).dependent(:destroy) }
    it { is_expected.to have_many(:enrollments).dependent(:destroy) }
    it { is_expected.to have_many(:payments).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:belt).with_values(white: 0, blue: 1, purple: 2, brown: 3, black: 4) }
    it { is_expected.to define_enum_for(:status).with_values(active: 0, inactive: 1, suspended: 2) }
  end

  describe "scopes" do
    let(:academy) { create(:academy) }

    describe ".at_risk" do
      it "includes students with risk_flag health records" do
        student = create(:student, academy: academy)
        create(:health_record, :with_risk, student: student)
        expect(Student.at_risk).to include(student)
      end

      it "excludes students without risk_flag" do
        student = create(:student, academy: academy)
        create(:health_record, student: student, risk_flag: false)
        expect(Student.at_risk).not_to include(student)
      end
    end

    describe ".for_academy" do
      it "returns only students from the given academy" do
        student = create(:student, academy: academy)
        other_student = create(:student)
        expect(Student.for_academy(academy)).to include(student)
        expect(Student.for_academy(academy)).not_to include(other_student)
      end
    end
  end
end
