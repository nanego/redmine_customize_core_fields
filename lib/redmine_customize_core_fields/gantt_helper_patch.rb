
module GanttHelperWithCustomCoreFieldsSupport
  
  def line_for_issue(issue, options)
    user = User.current
    disabled_fields = issue.disabled_core_fields(user)
    if disabled_fields.include? 'done_ratio'
      issue = issue.clone.tap{|o| o.done_ratio = nil }
    end
    super(issue, options)
  end

end

Redmine::Helpers::Gantt.send(:prepend, GanttHelperWithCustomCoreFieldsSupport)
