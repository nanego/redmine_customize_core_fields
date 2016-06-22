class CreateCoreFieldsTable < ActiveRecord::Migration

  def self.up
    create_table 'core_fields', :force => true do |t|
      t.column 'identifier', :string, :null => false
      t.column 'position', :integer
      t.column 'visible', :boolean, default: true, :null => false
    end
  end

  def self.down
    drop_table :core_fields
  end
end
