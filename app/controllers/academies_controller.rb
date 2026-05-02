class AcademiesController < ApplicationController
  def edit
    @academy = current_academy
    authorize @academy
  end

  def update
    @academy = current_academy
    authorize @academy

    if @academy.update(academy_params)
      redirect_to edit_academy_path, notice: "Configurações salvas."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def academy_params
    params.require(:academy).permit(:name)
  end
end
