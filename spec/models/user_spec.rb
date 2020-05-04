# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to be_a described_class }

  describe '#populate_ldap_attributes' do
    let(:user) { described_class.create!(access_id: 'jqd123', is_admin: false) }

    let(:ldap_mock_response) {
      {
        first_name: 'Joe',
        last_name: 'Developer',
        primary_affiliation: 'STAFF',
        groups: [],
        admin_area: 'UNIVERSITY LIBRARIES'
      }
    }

    before do
      allow(PsuLdapService).to receive(:find).and_return(ldap_mock_response)
    end

    context 'when the user is a member of the admin group' do
      before { ldap_mock_response[:groups] = ['umg/up.ul.dsrd.sudoers'] }

      it 'updates the user, setting is_admin to true' do
        expect { user.populate_ldap_attributes }
          .to change { user.reload.is_admin }
          .from(false)
          .to(true)
      end
    end

    context 'when the user is not a member of the admin group' do
      before { ldap_mock_response[:groups] = ['cn=umg/hosers'] }

      it 'does not set the user to be an admin' do
        expect { user.populate_ldap_attributes }
          .not_to change { user.reload.is_admin }
          .from(false)
      end
    end
  end
end
