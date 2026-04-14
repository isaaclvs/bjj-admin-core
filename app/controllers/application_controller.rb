class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include AcademyContext
  include Pagy::Backend

  prepend_before_action :authenticate_user!

  allow_browser versions: :modern
  stale_when_importmap_changes

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para realizar esta ação."
    redirect_back_or_to root_path
  end
end
