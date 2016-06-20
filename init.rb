Redmine::Plugin.register :redmine_customize_standard_fields do
  name 'Redmine Customize Standard Fields plugin'
  author 'Vincent ROBERT'
  description 'This Redmine plugin lets you customize standard fields'
  version '1.0.0'
  url 'https://github.com/nanego/redmine_customize_standard_fields'
  author_url 'https://github.com/nanego'
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
end
