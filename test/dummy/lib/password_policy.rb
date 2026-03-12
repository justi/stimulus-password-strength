# frozen_string_literal: true

module PasswordPolicy
  MIN_LENGTH = 12

  REQUIREMENTS = [
    {
      rule: :min_length,
      value: MIN_LENGTH,
      label: "At least #{MIN_LENGTH} characters",
      remaining_singular: "Type 1 more character",
      remaining_plural: "Type %{count} more characters",
      met_label: "#{MIN_LENGTH}+ chars"
    }
  ].freeze

  def self.requirements
    REQUIREMENTS
  end
end
