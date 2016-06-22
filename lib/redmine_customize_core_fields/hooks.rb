module RedmineCustomizeCoreFields
  class Hooks < Redmine::Hook::ViewListener

    # Add our css/js on each page
    def view_layouts_base_html_head(context)
      stylesheet_link_tag('core_fields.css', plugin: 'redmine_customize_core_fields')
    end

  end
end
