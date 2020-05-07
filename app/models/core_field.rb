class CoreField < ActiveRecord::Base
  include Redmine::SafeAttributes

  has_and_belongs_to_many :roles, :join_table => "core_fields_roles", :foreign_key => "core_field_id"
  acts_as_positioned

  safe_attributes :identifier, :id, :position, :visible, :role_ids

  after_save do |field|
    if field.visible_changed? && field.visible
      field.roles.clear
    end
  end

  scope :not_visible, lambda {|project, user = nil|
    user ||= User.current
    return none if user.admin? or (project.present? and !project.module_enabled?("customize_core_fields"))
    chain = where visible: false
    if project.present? 
      chain = chain.where("#{table_name}.id NOT IN (SELECT DISTINCT cfr.core_field_id FROM #{Member.table_name} m" +
                " INNER JOIN #{MemberRole.table_name} mr ON mr.member_id = m.id" +
                " INNER JOIN #{table_name_prefix}core_fields_roles#{table_name_suffix} cfr ON cfr.role_id = mr.role_id" +
                " WHERE m.user_id = ? AND m.project_id = ?)",
            user.id, project.id)
    end
    chain
  }

  def self.not_visible_identifiers(project, user = nil)
    not_visible(project, user).pluck(:identifier)
  end

  scope :sorted, lambda { order(:position) }

  def to_s
    identifier
  end

end
