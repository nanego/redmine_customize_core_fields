require_dependency 'journal'

# Store the original method before patching
Journal.class_eval do
  alias_method :visible_details_original, :visible_details unless method_defined?(:visible_details_original)
end

module RedmineCustomizeCoreFields
  module JournalPatch

    def visible_details(user = User.current)

      details = visible_details_original(user)
      return details if user.admin? || issue.nil?

      disabled_fields = issue.disabled_core_fields(user)
      details.reject { |detail|
        detail.property == 'attr' && disabled_fields.include?(detail.prop_key)
      }
    end

  end
end

Journal.include RedmineCustomizeCoreFields::JournalPatch
