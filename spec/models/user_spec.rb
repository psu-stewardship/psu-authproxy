# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.create!(access_id: 'jqd123', is_admin: false) }

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

  describe '#groups' do
    context 'with an empty LDAP response' do
      let(:ldap_mock_response) { {} }

      its(:groups) { is_expected.to eq([]) }
    end

    context 'when the user is a member of a group' do
      let(:ldap_mock_response) { { groups: ['mygroup'] } }

      its(:groups) { is_expected.to eq(['mygroup']) }
    end

    context 'when the response is a string' do
      let(:ldap_mock_response) { { groups: 'mystringgroup' } }

      its(:groups) { is_expected.to eq(['mystringgroup']) }
    end
  end

  describe '#surname' do
    let(:ldap_mock_response) { { surname: 'Jones' } }

    its(:surname) { is_expected.to eq('Jones') }
  end

  describe '#given_name' do
    let(:ldap_mock_response) { { given_name: 'Indiana' } }

    its(:given_name) { is_expected.to eq('Indiana') }
  end

  describe '#populate_ldap_attributes' do
    context 'when the user is a member of the admin group' do
      before { ldap_mock_response[:groups] = ['cn=umg/up.ul.dsrd.sudoers,dc=psu,dc=edu'] }

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
