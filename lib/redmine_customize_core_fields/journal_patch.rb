module RedmineCustomizeCoreFields
  module JournalPatch

    def visible_details(user = User.current)
      details = super(user)
      return details if user.admin? || journalized_type != 'Issue'

      # Important: use journalized (polymorphic association) instead of issue (belongs_to association)
      # to avoid loading a fresh Issue from DB which would corrupt @custom_field_values
      # in journalize_changes for subsequent saves on the same journal object.
      current_issue = journalized
      return details if current_issue.nil?

      disabled_fields = current_issue.disabled_core_fields(user)
      details.reject { |detail|
        detail.property == 'attr' && disabled_fields.include?(detail.prop_key)
      }
    end

  end
end

Journal.prepend RedmineCustomizeCoreFields::JournalPatch
