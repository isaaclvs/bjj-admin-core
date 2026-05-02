require "rails_helper"

RSpec.describe "Enrollments", type: :request do
  let(:academy) { create(:academy) }
  let(:owner)   { create(:user, academy: academy, role: :owner) }
  let(:student) { create(:student, academy: academy) }
  let(:plan)    { create(:plan, academy: academy) }

  before { sign_in owner }

  describe "POST /enrollments" do
    it "creates an enrollment when student and plan belong to the academy" do
      expect {
        post enrollments_path, params: { enrollment: {
          student_id: student.id, plan_id: plan.id, started_at: Date.today
        } }
      }.to change(Enrollment, :count).by(1)
    end

    it "rejects an enrollment with a student from another academy" do
      foreign_student = create(:student)
      expect {
        post enrollments_path, params: { enrollment: {
          student_id: foreign_student.id, plan_id: plan.id, started_at: Date.today
        } }
      }.not_to change(Enrollment, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects an enrollment with a plan from another academy" do
      foreign_plan = create(:plan)
      expect {
        post enrollments_path, params: { enrollment: {
          student_id: student.id, plan_id: foreign_plan.id, started_at: Date.today
        } }
      }.not_to change(Enrollment, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "automatically creates the first payment" do
      expect {
        post enrollments_path, params: { enrollment: {
          student_id: student.id, plan_id: plan.id, started_at: Date.today
        } }
      }.to change(Payment, :count).by(1)
    end
  end
end
