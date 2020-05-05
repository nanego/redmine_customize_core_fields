class UniqueIndexForIdentifierInCoreFields < ActiveRecord::Migration[4.2]
  def change
    add_index :core_fields, :identifier, unique: true, name: :unique_identifier
  end
end
