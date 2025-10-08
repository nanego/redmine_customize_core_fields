module RedmineCustomizeCoreFields
  module JournalPatch

    def visible_details(user = User.current)
      details = super(user)
      return details if user.admin? || issue.nil?

      disabled_fields = issue.disabled_core_fields(user)
      details.reject { |detail|
        detail.property == 'attr' && disabled_fields.include?(detail.prop_key)
      }
    end

  end
end

Journal.prepend RedmineCustomizeCoreFields::JournalPatch
