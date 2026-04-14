class StudentsController < ApplicationController
  before_action :set_student, only: %i[show edit update destroy]

  def index
    @pagy, @students = pagy(StudentsFilterQuery.new(current_academy, filter_params).call)
  end

  def show
  end

  def new
    @student = Student.new
    authorize @student
  end

  def create
    @student = current_academy.students.new(student_params)
    authorize @student

    if @student.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @student, notice: "Aluno cadastrado com sucesso." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @student.update(student_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @student, notice: "Aluno atualizado." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@student) }
      format.html { redirect_to students_path, notice: "Aluno removido." }
    end
  end

  private

  def set_student
    @student = current_academy.students.find(params[:id])
    authorize @student
  end

  def student_params
    params.require(:student).permit(
      :name, :cpf, :phone, :email, :belt,
      :birth_date, :emergency_contact_name,
      :emergency_contact_phone, :status, :enrolled_at
    )
  end

  def filter_params
    params.permit(:q, :belt, :status, :at_risk)
  end
end
