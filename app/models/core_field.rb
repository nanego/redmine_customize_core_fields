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

  scope :not_visible, lambda {|project|
    user = User.current
    if user.memberships.any? && project.present?
      where("#{table_name}.visible = ? AND #{table_name}.id NOT IN (SELECT DISTINCT cfr.core_field_id FROM #{Member.table_name} m" +
                " INNER JOIN #{MemberRole.table_name} mr ON mr.member_id = m.id" +
                " INNER JOIN #{table_name_prefix}core_fields_roles#{table_name_suffix} cfr ON cfr.role_id = mr.role_id" +
                " WHERE m.user_id = ? AND m.project_id = ?)",
            false, user.id, project.id)
    else
      where(:visible => false)
    end
  }

  scope :sorted, lambda { order(:position) }

  def to_s
    identifier
  end

end
