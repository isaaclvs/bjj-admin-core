module Public
  class RegistrationsController < ActionController::Base
    include Pagy::Backend

    layout "public"

    before_action :set_academy

    def new
      @student      = Student.new
      @health_record = @student.build_health_record
    end

    def create
      @student = @academy.students.new(student_params)
      @health_record = @student.build_health_record(health_record_params)

      if @student.save
        redirect_to public_registration_path(@academy.slug),
                    notice: "Cadastro realizado! Aguarde o contato da academia."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_academy
      @academy = Academy.find_by!(slug: params[:academy_slug])
    end

    def student_params
      params.require(:student).permit(
        :name, :cpf, :phone, :email, :belt,
        :birth_date, :emergency_contact_name, :emergency_contact_phone
      )
    end

    def health_record_params
      params.require(:health_record).permit(
        :blood_type, :uses_medication, :medication_notes,
        :risk_notes, :signature_data, :lgpd_consent,
        comorbidities: [], allergies: [], injuries: []
      )
    end
  end
end
