class UsersController < ApplicationController
  before_action :set_user, only: %i[destroy]

  def index
    authorize User
    @users = current_academy.users.order(:email)
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = current_academy.users.new(user_params)
    @user.role = params.dig(:user, :role).presence_in(%w[teacher owner]) || "teacher"
    @user.password = SecureRandom.hex(12)
    authorize @user

    if @user.save
      redirect_to users_path, notice: "Usuário criado. Peça para ele redefinir a senha em 'Esqueci minha senha'."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path, alert: "Você não pode remover a si mesmo."
    else
      @user.destroy
      redirect_to users_path, notice: "Usuário removido."
    end
  end

  private

  def set_user
    @user = current_academy.users.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
