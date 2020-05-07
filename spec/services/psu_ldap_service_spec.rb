# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PsuLdapService do
  describe '.find' do
    subject { described_class.find(user_id) }

    context 'given a valid psu user id' do
      let(:user_id) { 'djb44' }

      it { is_expected.to be_a(LdapUser) }
      its(:uid) { is_expected.to eq('djb44') }
      its(:last_name) { is_expected.to eq('Bohn') }
      its(:first_name) { is_expected.to eq('Dann') }
      its(:surname) { is_expected.to eq('Bohn') }
      its(:given_name) { is_expected.to eq('Dann') }
      its(:primary_affiliation) { is_expected.to eq 'STAFF' }
      its(:groups) { is_expected.to include('cn=psu.up.all,dc=psu,dc=edu') }
      its(:admin_area) { is_expected.to be_a(String) }
    end

    context 'given a bogus psu user id' do
      let(:user_id) { 'completelybogus' }

      it { is_expected.to be_a(LdapUser) }
      its(:uid) { is_expected.to be_nil }
      its(:last_name) { is_expected.to be_nil }
      its(:first_name) { is_expected.to be_nil }
      its(:surname) { is_expected.to be_nil }
      its(:given_name) { is_expected.to be_nil }
      its(:primary_affiliation) { is_expected.to be_nil }
      its(:groups) { is_expected.to be_empty }
      its(:admin_area) { is_expected.to be_nil }
    end

    context 'given a nul user id' do
      let(:user_id) { nil }

      it { is_expected.to be_a(LdapUser) }
      its(:uid) { is_expected.to be_nil }
      its(:last_name) { is_expected.to be_nil }
      its(:first_name) { is_expected.to be_nil }
      its(:surname) { is_expected.to be_nil }
      its(:given_name) { is_expected.to be_nil }
      its(:primary_affiliation) { is_expected.to be_nil }
      its(:groups) { is_expected.to be_empty }
      its(:admin_area) { is_expected.to be_nil }
    end

    context 'given a specially malformed user id' do
      let(:user_id) { 'la;ksjf;lkasjdflj' }

      it do
        pending 'Need an appropriate example'
        expect(attrs).to eq({})
      end
    end
  end
end
