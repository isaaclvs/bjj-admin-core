class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[edit update destroy]

  def index
    authorize Payment
    @pagy, @payments = pagy(
      current_academy.payments
        .includes(enrollment: [ :plan, :student ])
        .order(due_date: :asc)
    )
    @overdue_count = OverduePaymentsQuery.new(current_academy).call.count
  end

  def new
    @payment = Payment.new
    authorize @payment
    @enrollments = current_academy.enrollments.active
                                  .includes(:student, :plan)
                                  .order("students.name")
  end

  def create
    @payment = Payment.new(payment_params)
    authorize @payment

    unless current_academy.enrollments.exists?(@payment.enrollment_id)
      @enrollments = current_academy.enrollments.active.includes(:student, :plan).order("students.name")
      return render :new, status: :unprocessable_entity
    end

    if @payment.save
      respond_to do |format|
        format.html { redirect_to payments_path, notice: "Pagamento registrado." }
      end
    else
      @enrollments = current_academy.enrollments.active.includes(:student, :plan).order("students.name")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @payment.update(payment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to payments_path, notice: "Pagamento atualizado." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @payment.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@payment) }
      format.html { redirect_to payments_path, notice: "Pagamento removido." }
    end
  end

  private

  def set_payment
    @payment = current_academy.payments.find(params[:id])
    authorize @payment
  end

  def payment_params
    params.require(:payment).permit(:enrollment_id, :amount_cents, :due_date, :method, :status, :notes, :paid_at)
  end
end
