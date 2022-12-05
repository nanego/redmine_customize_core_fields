require_dependency 'issue'

class Issue

  def disabled_core_fields(user=User.current)
    disabled_core_fields = tracker ? tracker.disabled_core_fields : []
    disabled_core_fields | CoreField.not_visible_identifiers(project, user)
  end

end
