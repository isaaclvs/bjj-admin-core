class EnrollmentsController < ApplicationController
  def new
    @enrollment = Enrollment.new
    @students   = current_academy.students.active.order(:name)
    @plans      = current_academy.plans.active.order(:name)
    authorize @enrollment
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    authorize @enrollment

    unless current_academy.students.exists?(@enrollment.student_id)
      return render :new, status: :unprocessable_entity
    end

    if @enrollment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to students_path, notice: "Matrícula realizada com sucesso." }
      end
    else
      @students = current_academy.students.active.order(:name)
      @plans    = current_academy.plans.active.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @enrollment = Enrollment.joins(:student).where(students: { academy: current_academy }).find(params[:id])
    authorize @enrollment
    @enrollment.update!(status: :cancelled)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@enrollment) }
      format.html { redirect_to students_path, notice: "Matrícula cancelada." }
    end
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:student_id, :plan_id, :started_at, :expires_at)
  end
end
