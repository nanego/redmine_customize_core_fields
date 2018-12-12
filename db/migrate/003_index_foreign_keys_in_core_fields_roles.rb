class IndexForeignKeysInCoreFieldsRoles < ActiveRecord::Migration[4.2]
  def change
    add_index :core_fields_roles, :role_id
  end
end
