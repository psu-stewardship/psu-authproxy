# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LdapController, type: :controller do
  describe 'find' do
    before(:each) do
      @ldap = LdapController.new
    end

    it 'should return one result' do
      thing = @ldap.find('djb44')
      expect(thing.length).to eq(1)
    end

    it 'should return no results' do
      thing = @ldap.find('jfdlajflkdsajfl')
      expect(thing.length).to eq(0)
    end
  end
end
