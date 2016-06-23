module CoreFieldsHelper
  include ApplicationHelper

  def core_field_title(field)
    l("field_#{field}".sub(/_id$/, ''))
  end
end
