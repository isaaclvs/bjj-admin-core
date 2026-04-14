class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]

  def index
    @plans = current_academy.plans.order(:name)
    authorize Plan
  end

  def show
  end

  def new
    @plan = Plan.new
    authorize @plan
  end

  def create
    @plan = current_academy.plans.new(plan_params)
    authorize @plan

    if @plan.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @plan, notice: "Plano criado com sucesso." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @plan, notice: "Plano atualizado." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@plan) }
      format.html { redirect_to plans_path, notice: "Plano removido." }
    end
  end

  private

  def set_plan
    @plan = current_academy.plans.find(params[:id])
    authorize @plan
  end

  def plan_params
    params.require(:plan).permit(:name, :price_cents, :interval, :description, :active)
  end
end
