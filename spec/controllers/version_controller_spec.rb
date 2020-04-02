
require 'rails_helper'

RSpec.describe VersionController do 
    describe '#show' do

        context 'has APP_VERSION' do
            before do 
                ENV['APP_VERSION'] = "1"
            end
            it 'returns 1' do
                get(:show)
                expect(response.status).to eq(200)
                body = JSON.parse(response.body)
                expect(body['version']).to eq("1")
            end
        end

        context 'has no APP_VERSION' do
            before do
                ENV['APP_VERSION'] = nil
            end
            it 'returns no version' do
                get(:show)
                expect(response.status).to eq(200)
                body = JSON.parse(response.body)
                expect(body['version']).to eq("No Version Given")
            end
        end

    end
end