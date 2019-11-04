require_dependency 'issue'

class Issue

  def disabled_core_fields
    disabled_core_fields = tracker ? tracker.disabled_core_fields : []
    if self.project.present? && self.project.module_enabled?("customize_core_fields")
      disabled_core_fields | CoreField.not_visible(project).map(&:identifier).uniq
    end
    disabled_core_fields
  end

end
