# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/services/psu_ldap_service'

RSpec.describe PsuLdapService do
  describe '.find' do
    subject(:attrs) { described_class.find(user_id) }

    context 'given a valid psu user id' do
      let(:user_id) { 'djb44' }

      it 'should return a result' do
        expect(attrs[:last_name]).to eq('Bohn')
        expect(attrs[:first_name]).to eq('Dann')
        expect(attrs[:primary_affiliation]).to eq 'STAFF'
        expect(attrs[:groups]).to include('cn=psu.up.all,dc=psu,dc=edu')
        expect(attrs[:admin_area]).to be_a(String)
      end
    end

    context 'given a bogus psu user id' do
      let(:user_id) { 'completelybogus' }

      it { is_expected.to be_nil }
    end

    context 'given a specially malformed user id' do
      let(:user_id) { 'la;ksjf;lkasjdflj' }

      xit { is_expected.to be_nil }
    end
  end
end
