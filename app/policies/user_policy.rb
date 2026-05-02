class UserPolicy < ApplicationPolicy
  def index?   = user.owner?
  def new?     = user.owner?
  def create?  = user.owner?
  def destroy? = user.owner?
end
