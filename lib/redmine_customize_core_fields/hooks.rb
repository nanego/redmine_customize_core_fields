module RedmineCustomizeCoreFields
  class Hooks < Redmine::Hook::ViewListener
    # Add our css/js on each page
    def view_layouts_base_html_head(context)
      stylesheet_link_tag('core_fields.css', plugin: 'redmine_customize_core_fields')
    end
  end

  class ModelHook < Redmine::Hook::Listener
    def after_plugins_loaded(_context = {})
      require_relative 'issue_patch'
      require_relative 'journal_patch'
      require_relative 'query_patch'
      require_relative 'role_patch'
    end
  end
end
