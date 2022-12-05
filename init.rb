require 'redmine'
require_relative 'lib/redmine_customize_core_fields/hooks'

Redmine::Plugin.register :redmine_customize_core_fields do
  name 'Redmine Customize Core Fields plugin'
  author 'Vincent ROBERT'
  description 'This Redmine plugin lets you customize core fields'
  version '1.0.0'
  url 'https://github.com/nanego/redmine_customize_core_fields'
  author_url 'https://github.com/nanego'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
  menu :admin_menu, :redmine_customize_core_fields, {:controller => 'core_fields', :action => 'index'}, :after => :custom_fields, :caption => :field_core_fields, html: {class: 'icon'}
  project_module :customize_core_fields do
    permission :update_core_fields, {}
  end
  settings :default => {'override_issue_form' => 'false',
                        'display_custom_fields_first' => 'true'},
           :partial => 'settings/redmine_plugin_customize_core_fields'
end
