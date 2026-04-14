class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show edit update destroy]

  def index
    authorize Payment
    @pagy, @payments = pagy(
      current_academy.payments
        .includes(:student, enrollment: :plan)
        .order(due_date: :asc)
    )
    @overdue_count = OverduePaymentsQuery.new(current_academy).call.count
  end

  def show
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
      format.html { redirect_to payments_path }
    end
  end

  private

  def set_payment
    @payment = current_academy.payments.find(params[:id])
    authorize @payment
  end

  def payment_params
    params.require(:payment).permit(:amount_cents, :due_date, :method, :status, :notes, :paid_at)
  end
end
