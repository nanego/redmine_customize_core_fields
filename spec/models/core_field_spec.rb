require 'spec_helper'

describe CoreField do

  fixtures :roles, :projects,
           :trackers, :issue_statuses,
           :issues

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
    it 'tests visibile scope with non admin user' do
      CoreField.delete_all
      fields = [
          CoreField.create!(identifier: 'assigned_to_id', :visible => true),
          CoreField.create!(identifier: 'project_id', :visible => false),
          CoreField.create!(identifier: 'category_id', :visible => false, :role_ids => [1, 2]),
          CoreField.create!(identifier: 'tracker_id', :visible => false, :role_ids => [2, 3]),
      ]
      membership = Member.first # user_id: 2, project_id: 1, roles: [1]
      User.current = membership.user
      expect(CoreField.not_visible(membership.project).order("id").to_a).to eq [fields[1], fields[3]]
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
      expect(CoreField.not_visible(Project.find_by_id(1)).order("id").to_a).to eq [fields[1], fields[2], fields[3]]
    end
  end

end
