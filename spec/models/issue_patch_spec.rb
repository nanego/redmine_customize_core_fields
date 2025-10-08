require 'spec_helper'

describe Issue do
  fixtures :projects, :users, :roles, :members, :member_roles, :issues, :issue_statuses,
           :versions, :trackers, :projects_trackers, :issue_categories, :enabled_modules, :enumerations

  let(:project) { Project.find(1) }
  let(:tracker) { project.trackers.first }
  let(:issue) { Issue.create!(project: project, tracker: tracker, author_id: 1, subject: 'Test issue') }
  let(:admin_user) { User.find(1) }
  let(:non_admin_user) { User.find(2) }

  before do
    project.enable_module!('customize_core_fields')
  end

  describe '#disabled_core_fields' do
    context 'without any restrictions' do
      it 'returns empty array when no core fields are disabled' do
        disabled_fields = issue.disabled_core_fields(non_admin_user)
        expect(disabled_fields).to eq([])
      end
    end

    context 'with tracker-level restrictions' do
      it 'includes tracker disabled core fields' do
        # Mock tracker disabled fields
        allow(tracker).to receive(:disabled_core_fields).and_return(['assigned_to_id'])

        disabled_fields = issue.disabled_core_fields(non_admin_user)

        expect(disabled_fields).to include('assigned_to_id')
      end
    end

    context 'with project-level restrictions' do
      it 'includes project disabled core fields for user' do
        # Create project-level restrictions
        CoreField.create!(identifier: 'category_id', visible: false)

        disabled_fields = issue.disabled_core_fields(non_admin_user)

        expect(disabled_fields).to include('category_id')
      end

      it 'combines tracker and project restrictions' do
        # Mock tracker restriction
        allow(tracker).to receive(:disabled_core_fields).and_return(['assigned_to_id'])

        # Create project restriction
        CoreField.create!(identifier: 'category_id', visible: false)

        disabled_fields = issue.disabled_core_fields(non_admin_user)

        expect(disabled_fields).to include('assigned_to_id', 'category_id')
        expect(disabled_fields.uniq).to eq(disabled_fields) # No duplicates
      end
    end

    context 'with role-based restrictions' do
      it 'excludes fields that user has role access to' do
        # Create a role and assign to user
        role = Role.create!(name: 'Special Role', permissions: [])
        member = Member.find_by(user: non_admin_user, project: project)
        member.roles = [role]
        member.save!

        # Create core field restricted but accessible to this role
        field = CoreField.find_or_create_by!(identifier: 'assigned_to_id', visible: false)
        field.role_ids = [role.id]

        disabled_fields = issue.disabled_core_fields(non_admin_user)

        # Should not include the field since user has the required role
        expect(disabled_fields).not_to include('assigned_to_id')
      end

      it 'includes fields that user does not have role access to' do
        # Create a role NOT assigned to user
        other_role = Role.create!(name: 'Other Role', permissions: [])

        # Create core field restricted to other role only
        field = CoreField.find_or_create_by!(identifier: 'assigned_to_id', visible: false)
        field.role_ids = [other_role.id]

        disabled_fields = issue.disabled_core_fields(non_admin_user)

        # Should include the field since user doesn't have the required role
        expect(disabled_fields).to include('assigned_to_id')
      end
    end
  end
end
