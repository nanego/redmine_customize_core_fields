require 'spec_helper'

require_relative '../../lib/redmine_customize_core_fields/journal_patch'

describe Journal do
  fixtures :projects, :users, :roles, :members, :member_roles, :issues, :issue_statuses,
           :versions, :trackers, :projects_trackers, :issue_categories, :enabled_modules,
           :enumerations, :attachments, :workflows, :custom_fields, :custom_values,
           :custom_fields_projects, :custom_fields_trackers, :time_entries,
           :journals, :journal_details

  let(:project) { Project.find(1) }
  let(:tracker) { project.trackers.first }
  let(:issue) { Issue.create!(project: project, tracker: tracker, author_id: 1, subject: 'Test issue') }
  let(:admin_user) { User.find(1) }
  let(:non_admin_user) { User.find(2) }
  let(:journal) { Journal.create!(journalized: issue, user: admin_user) }

  before do
    project.enable_module!('customize_core_fields')
  end

  describe '#visible_details' do
    context 'with admin user' do
      it 'shows all details regardless of core field configuration' do
        # Create some core field restrictions
        CoreField.find_or_create_by!(identifier: 'assigned_to_id', visible: false)

        # Create journal details
        journal.details.create!(property: 'attr', prop_key: 'assigned_to_id', old_value: '', value: '2')
        journal.details.create!(property: 'attr', prop_key: 'subject', old_value: 'Old', value: 'New')
        journal.details.create!(property: 'cf', prop_key: '1', old_value: '', value: 'test')

        visible_details = journal.visible_details(admin_user)

        expect(visible_details.size).to eq(3)
        expect(visible_details.map(&:prop_key)).to include('assigned_to_id', 'subject', '1')
      end
    end

    context 'with non-admin user' do
      context 'when core fields are not restricted' do
        it 'shows all details when no restrictions are configured' do
          # No core field restrictions

          # Create journal details
          journal.details.create!(property: 'attr', prop_key: 'assigned_to_id', old_value: '', value: '2')
          journal.details.create!(property: 'attr', prop_key: 'subject', old_value: 'Old', value: 'New')
          journal.details.create!(property: 'cf', prop_key: '1', old_value: '', value: 'test')

          visible_details = journal.visible_details(non_admin_user)

          expect(visible_details.size).to eq(3)
          expect(visible_details.map(&:prop_key)).to include('assigned_to_id', 'subject', '1')
        end
      end

      context 'when core fields are restricted' do
        it 'filters out restricted core fields for non-admin users' do
          # Create core field restrictions for non-admin users
          field = CoreField.find_or_create_by!(identifier: 'assigned_to_id', visible: false)
          field.role_ids = []
          field.save!

          # Create journal details
          journal.details.create!(property: 'attr', prop_key: 'assigned_to_id', old_value: '', value: '2')
          journal.details.create!(property: 'attr', prop_key: 'subject', old_value: 'Old', value: 'New')
          journal.details.create!(property: 'cf', prop_key: '1', old_value: '', value: 'test')

          visible_details = journal.visible_details(non_admin_user)

          # Should filter out 'assigned_to_id' but keep 'subject' and custom field
          expect(visible_details.size).to eq(2)
          expect(visible_details.map(&:prop_key)).to include('subject', '1')
          expect(visible_details.map(&:prop_key)).not_to include('assigned_to_id')
        end

        it 'keeps custom fields even when core fields are restricted' do
          # Create core field restrictions
          CoreField.find_or_create_by!(identifier: 'assigned_to_id', visible: false)
          CoreField.find_or_create_by!(identifier: 'subject', visible: false)

          # Create journal details including custom field
          journal.details.create!(property: 'attr', prop_key: 'assigned_to_id', old_value: '', value: '2')
          journal.details.create!(property: 'cf', prop_key: '1', old_value: '', value: 'test')
          journal.details.create!(property: 'relation', prop_key: 'relates', old_value: '', value: '3')

          visible_details = journal.visible_details(non_admin_user)

          # Should keep custom field and relation but filter core field
          expect(visible_details.size).to eq(2)
          expect(visible_details.map(&:prop_key)).to include('1', 'relates')
          expect(visible_details.map(&:prop_key)).not_to include('assigned_to_id')
        end
      end
    end

  end
end
