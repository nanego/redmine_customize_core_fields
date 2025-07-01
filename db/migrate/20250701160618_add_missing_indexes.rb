class AddMissingIndexes < ActiveRecord::Migration[7.2]
  def change
    add_index :core_fields_roles, :core_field_id, if_not_exists: true
  end
end
