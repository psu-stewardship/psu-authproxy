# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'GET #show' do
    context 'with a valid Dookkeeper token' do
      let(:user) { create(:user, access_id: 'djb44') }
      let(:token) { instance_double('Doorkeeper::AccessToken', resource_owner_id: user.id, acceptable?: true) }
      let(:json) { JSON.parse(response.body) }

      before do
        allow(controller).to receive(:doorkeeper_token) { token }
        get :show
      end

      it 'returns information about the user' do
        expect(response).to be_successful
        expect(json['email']).to eq(user.email)
        expect(json['given_name']).to eq(user.given_name)
      end
    end

    context 'without a valid token' do
      subject { response }

      before { get :show }

      it { is_expected.to be_unauthorized }
    end
  end
end
