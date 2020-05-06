# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LdapUser, type: :model do
  describe '.attributes' do
    subject { described_class }

    its(:attributes) do
      is_expected.to contain_exactly(
        :groups,
        :surname,
        :last_name,
        :given_name,
        :first_name,
        :primary_affiliation,
        :uid,
        :admin_area
      )
    end
  end

  describe 'attributes from the Net::LDAP:Entry' do
    subject { described_class.new(user.instance_variable_get(:@ldap_entry)) }

    let(:user) { build(:ldap_user) }

    its(:groups) { is_expected.to eq(user.groups) }
    its(:surname) { is_expected.to eq(user.surname) }
    its(:last_name) { is_expected.to eq(user.last_name) }
    its(:given_name) { is_expected.to eq(user.given_name) }
    its(:first_name) { is_expected.to eq(user.first_name) }
    its(:primary_affiliation) { is_expected.to eq(user.primary_affiliation) }
    its(:uid) { is_expected.to eq(user.uid) }
    its(:admin_area) { is_expected.to eq(user.admin_area) }
  end
end
