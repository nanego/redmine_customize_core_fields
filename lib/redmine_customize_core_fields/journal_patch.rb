require_dependency 'journal'

module JournalWithCustomCoreFieldsSupport

  def visible_details(user=User.current)
    details = super(user)
    return details if user.admin? or issue.nil?
    disabled_fields = issue.disabled_core_fields(user)
    details.reject{|o| disabled_fields.include? o.prop_key }
  end

end

Journal.send(:prepend, JournalWithCustomCoreFieldsSupport)

