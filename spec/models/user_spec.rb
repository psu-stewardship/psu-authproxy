# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  let(:ldap_user) { build(:ldap_user, access_id: user.access_id) }

  before { allow(PsuLdapService).to receive(:find).and_return(ldap_user) }

  describe '#as_json' do
    subject(:json) { user.as_json }

    let(:json_keys) { LdapUser.attributes + [:access_id, :email] }

    it 'uses a customized json representation' do
      json_keys.each do |attribute|
        expect(json).to include(attribute.to_s => user.send(attribute))
      end
    end
  end

  describe '#groups' do
    its(:groups) do
      is_expected.to eq(ldap_user.groups)
      is_expected.not_to be_empty
    end
  end

  describe '#surname' do
    its(:surname) do
      is_expected.to eq(ldap_user.surname)
      is_expected.not_to be_nil
    end
  end

  describe '#given_name' do
    its(:given_name) do
      is_expected.to eq(ldap_user.given_name)
      is_expected.not_to be_nil
    end
  end

  describe '#populate_ldap_attributes' do
    context 'when the user is a member of the admin group' do
      let(:ldap_user) { build(:ldap_user, :is_admin, access_id: user.access_id) }

      it 'updates the user, setting is_admin to true' do
        expect { user.populate_ldap_attributes }
          .to change { user.reload.is_admin }
          .from(false)
          .to(true)
      end
    end

    context 'when the user is not a member of the admin group' do
      it 'does not set the user to be an admin' do
        expect { user.populate_ldap_attributes }
          .not_to change { user.reload.is_admin }
          .from(false)
      end
    end
  end
end
