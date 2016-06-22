class CreateCoreFieldsRoles < ActiveRecord::Migration
  def self.up
    create_table :core_fields_roles, :id => false do |t|
      t.column :core_field_id, :integer, :null => false
      t.column :role_id, :integer, :null => false
    end
    add_index :core_fields_roles, [:core_field_id, :role_id], :unique => true, :name => :core_fields_roles_ids
  end

  def self.down
    drop_table :core_fields_roles
  end
end
