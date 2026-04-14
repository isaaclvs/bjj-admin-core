class StudentsFilterQuery
  def initialize(academy, params = {})
    @academy = academy
    @params  = params
  end

  def call
    scope = Student.for_academy(@academy).includes(:health_record, :enrollments)
    scope = filter_by_belt(scope)
    scope = filter_by_status(scope)
    scope = filter_by_risk(scope)
    search(scope)
  end

  private

  def filter_by_belt(scope)
    return scope unless @params[:belt].present?
    scope.where(belt: @params[:belt])
  end

  def filter_by_status(scope)
    return scope unless @params[:status].present?
    scope.where(status: @params[:status])
  end

  def filter_by_risk(scope)
    return scope unless @params[:at_risk] == "1"
    scope.at_risk
  end

  def search(scope)
    return scope unless @params[:q].present?
    scope.where("name LIKE ?", "%#{@params[:q]}%")
  end
end
