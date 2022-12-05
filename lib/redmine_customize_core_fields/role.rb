require_dependency 'role'

class Role

  has_and_belongs_to_many :core_fields, :join_table => "core_fields_roles", :foreign_key => "role_id"

end