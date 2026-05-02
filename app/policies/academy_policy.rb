class AcademyPolicy < ApplicationPolicy
  def edit?   = user.owner?
  def update? = user.owner?
end
