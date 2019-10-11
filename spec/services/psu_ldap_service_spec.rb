# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/services/psu_ldap_service'

RSpec.describe PsuLdapService do
  describe '.find' do
    it 'should return a result' do
      attrs = described_class.find('djb44')
      expect(attrs[:last_name]).to eq("Bohn")
    end

    it 'should return no results' do
      thing = described_class.find('jfdlajflkdsajfl')
      expect(thing).to eq(nil)
    end
  end
end
