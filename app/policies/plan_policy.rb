class PlanPolicy < ApplicationPolicy
  def index?   = user.owner?
  def show?    = user.owner?
  def create?  = user.owner?
  def update?  = user.owner?
  def destroy? = user.owner?
end
