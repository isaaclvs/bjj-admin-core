require "rails_helper"

RSpec.describe "Students", type: :request do
  let(:academy) { create(:academy) }
  let(:owner)   { create(:user, academy: academy, role: :owner) }

  before { sign_in owner }

  describe "GET /students" do
    it "returns 200" do
      get students_path
      expect(response).to have_http_status(:ok)
    end

    it "only shows students from the signed-in academy" do
      own     = create(:student, academy: academy, name: "Meu Aluno")
      foreign = create(:student, name: "Outro Aluno")

      get students_path
      expect(response.body).to include("Meu Aluno")
      expect(response.body).not_to include("Outro Aluno")
    end
  end

  describe "POST /students" do
    let(:valid_params) do
      { student: { name: "Carlos Silva", belt: "white", status: "active" } }
    end

    it "creates a student scoped to the current academy" do
      expect { post students_path, params: valid_params }
        .to change(academy.students, :count).by(1)
    end

    it "does not create a student for another academy" do
      other = create(:academy)
      expect { post students_path, params: valid_params }
        .not_to change(other.students, :count)
    end

    it "redirects to the new student on success" do
      post students_path, params: valid_params
      expect(response).to redirect_to(student_path(Student.last))
    end

    it "renders :new on invalid params" do
      post students_path, params: { student: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /students/:id" do
    it "returns 404 when trying to delete a student from another academy" do
      foreign = create(:student)
      delete student_path(foreign)
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when signed in as teacher" do
    let(:teacher) { create(:user, academy: academy, role: :teacher) }

    before { sign_in teacher }

    it "cannot create a student" do
      post students_path, params: { student: { name: "Test", belt: "white", status: "active" } }
      expect(response).to redirect_to(root_path)
    end
  end
end
