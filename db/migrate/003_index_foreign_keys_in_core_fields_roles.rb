class IndexForeignKeysInCoreFieldsRoles < ActiveRecord::Migration
  def change
    add_index :core_fields_roles, :role_id
  end
end
