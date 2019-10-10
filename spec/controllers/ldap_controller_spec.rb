# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LdapController, type: :controller do
  describe 'find' do
    before(:each) do
      @ldap = LdapController.new
    end

    it 'should return a result' do
      thing = @ldap.find('djb44')
      expect(thing.uid[0]).to eq("djb44")
    end

    it 'should return no results' do
      thing = @ldap.find('jfdlajflkdsajfl')
      expect(thing).to eq(nil)
    end
  end
end
