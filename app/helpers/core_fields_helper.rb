module CoreFieldsHelper
  def core_field_title(field)
    l("field_#{field}".sub(/_id$/, ''))
  end
end
