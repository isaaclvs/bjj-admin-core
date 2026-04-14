class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def index?   = user.owner?
  def show?    = user.owner?
  def new?     = create?
  def create?  = user.owner?
  def edit?    = update?
  def update?  = user.owner?
  def destroy? = user.owner?

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve = scope.all

    private

    attr_reader :user, :scope
  end
end
