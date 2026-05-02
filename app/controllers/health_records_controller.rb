class HealthRecordsController < ApplicationController
  before_action :set_student
  before_action :set_health_record, only: %i[show edit update]

  def show
    authorize @health_record
  end

  def new
    @health_record = @student.build_health_record
    authorize @health_record
  end

  def create
    @health_record = @student.build_health_record(health_record_params)
    authorize @health_record

    if @health_record.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to student_health_record_path(@student), notice: "Ficha de saúde salva." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @health_record
  end

  def update
    authorize @health_record

    if @health_record.update(health_record_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to student_health_record_path(@student), notice: "Ficha de saúde atualizada." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_student
    @student = current_academy.students.find(params[:student_id])
  end

  def set_health_record
    @health_record = @student.health_record || not_found
  end

  def not_found
    raise ActiveRecord::RecordNotFound
  end

  def health_record_params
    params.require(:health_record).permit(
      :blood_type, :uses_medication, :medication_notes,
      :risk_notes, :signature_data, :lgpd_consent,
      comorbidities: [], allergies: [], injuries: []
    )
  end
end
