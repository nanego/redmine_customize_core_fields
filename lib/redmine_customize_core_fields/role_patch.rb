require_dependency 'role'

module RedmineCustomizeCoreFields
  module RolePatch
    def self.included(base)
      base.class_eval do
        has_and_belongs_to_many :core_fields, :join_table => "core_fields_roles", :foreign_key => "role_id"
      end
    end
  end
end

Role.include RedmineCustomizeCoreFields::RolePatch
