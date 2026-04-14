class StudentPolicy < ApplicationPolicy
  def index?   = true
  def show?    = true
  def create?  = user.owner?
  def update?  = user.owner?
  def destroy? = user.owner?
end
