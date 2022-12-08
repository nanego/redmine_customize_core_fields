require_dependency 'project'

module RedmineCustomizeCoreFields
  module Project
    def self.included(base)
      base.class_eval do
        attr_accessor :disabled_core_fields

        def disabled_core_fields(user = User.current)
          @disabled_core_fields ||= CoreField.not_visible_identifiers(self, user)
        end

      end
    end
  end
end

Project.send(:include, RedmineCustomizeCoreFields::Project)
