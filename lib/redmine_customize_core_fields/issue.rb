require_dependency 'issue'

module RedmineCustomizeCoreFields
  module Issue
    def disabled_core_fields(user = User.current)
      disabled_core_fields = tracker ? tracker.disabled_core_fields : []
      disabled_core_fields | project.disabled_core_fields(user) if project.present?
    end
  end
end

Issue.send(:prepend, RedmineCustomizeCoreFields::Issue)
