module AcademyScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :academy
    scope :for_academy, ->(academy) { where(academy: academy) }
  end
end
