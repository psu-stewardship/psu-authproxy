# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VersionController do
  describe '#show' do
    context 'when there is an APP_VERSION' do
      before do
        ENV['APP_VERSION'] = '1'
      end

      it 'returns 1' do
        get(:show)
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['version']).to eq('1')
      end
    end

    context 'when there is NO APP_VERSION' do
      before do
        ENV['APP_VERSION'] = nil
      end

      it 'returns no version' do
        get(:show)
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['version']).to eq('No Version Given')
      end
    end
  end
end
