module AcademyContext
  extend ActiveSupport::Concern

  included do
    before_action :set_current_academy
    helper_method :current_academy
  end

  private

  def current_academy
    @current_academy
  end

  def set_current_academy
    @current_academy = current_user&.academy
  end
end
