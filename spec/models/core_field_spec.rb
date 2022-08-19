require 'spec_helper'

describe CoreField do

  fixtures :roles, :projects,
           :trackers, :issue_statuses,
           :issues, :members, :users, :member_roles, :roles

  describe 'create and destroy' do
    it 'creates a record for the given core field' do
      field = CoreField.new(:identifier => 'assigned_to_id')
      expect(field.save).to eq true
      expect(field.visible).to eq true
    end

    it 'destroys a record' do
      field = CoreField.create(:identifier => 'assigned_to_id')
      expect(field.destroy).to eq field
    end
  end

  describe 'core fields visibility' do
    it 'tests visibility scope with admin user' do
      CoreField.delete_all
      fields = [
          CoreField.create!(identifier: 'assigned_to_id', :visible => true),
          CoreField.create!(identifier: 'project_id', :visible => false),
          CoreField.create!(identifier: 'category_id', :visible => false, :role_ids => [1, 2]),
          CoreField.create!(identifier: 'tracker_id', :visible => false, :role_ids => [2, 3]),
      ]
      user = User.first # user_id: 1
      User.current = user
      project = Project.find_by_id(1)
      project.enable_module! 'customize_core_fields'
      expect(CoreField.not_visible(project).order("id").to_a).to eq []
    end

    it 'tests visibility scope with non admin user' do
      CoreField.delete_all
      fields = [
          CoreField.create!(identifier: 'assigned_to_id', :visible => true),
          CoreField.create!(identifier: 'project_id', :visible => false),
          CoreField.create!(identifier: 'category_id', :visible => false, :role_ids => [1, 2]),
          CoreField.create!(identifier: 'tracker_id', :visible => false, :role_ids => [2, 3]),
      ]
      membership = Member.first # user_id: 2, project_id: 1, roles: [1]
      User.current = membership.user
      project = membership.project
      project.enable_module! 'customize_core_fields'
      expect(CoreField.not_visible(project).order("id").to_a).to eq [fields[1], fields[3]]
    end

    it 'tests visibility with anonymous user' do
      CoreField.delete_all
      fields = [
          CoreField.create!(identifier: 'assigned_to_id', :visible => true),
          CoreField.create!(identifier: 'project_id', :visible => false),
          CoreField.create!(identifier: 'category_id', :visible => false, :role_ids => [1, 2]),
          CoreField.create!(identifier: 'tracker_id', :visible => false, :role_ids => [2, 3]),
      ]
      User.current = User.anonymous
      project = Project.find_by_id(1)
      project.enable_module! 'customize_core_fields'
      expect(CoreField.not_visible(project).order("id").to_a).to eq [fields[1], fields[2], fields[3]]
    end

    it 'tests visibility with disabled module' do
      CoreField.delete_all
      fields = [
          CoreField.create!(identifier: 'assigned_to_id', :visible => true),
          CoreField.create!(identifier: 'project_id', :visible => false),
          CoreField.create!(identifier: 'category_id', :visible => false, :role_ids => [1, 2]),
          CoreField.create!(identifier: 'tracker_id', :visible => false, :role_ids => [2, 3]),
      ]
      User.current = User.anonymous
      project = Project.find_by_id(1)
      project.disable_module! 'customize_core_fields'
      expect(CoreField.not_visible(project).order("id").to_a).to eq []
    end
  end

  describe 'update the table core_fields_roles in case of cascade deleting' do
    it "when delete a role" do
      role_test = Role.create!(:name => 'Test')
      CoreField.create!(identifier: 'project_id', :visible => true, :role_ids => [1, role_test.id])
      expect(ActiveRecord::Base.connection.execute('select * from core_fields_roles').count).to eq(2)
      role_test.destroy
      expect(ActiveRecord::Base.connection.execute('select * from core_fields_roles').count).to eq(1)
    end
  end
end
