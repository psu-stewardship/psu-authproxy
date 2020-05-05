# frozen_string_literal: true

require 'rails_helper'
require 'oauth2'
require 'net/http'

describe 'OAuth Authorization Flow' do
  let(:app) { FactoryBot.create :application }
  let(:user) { FactoryBot.create :user }
  let(:client) { OAuth2::Client.new(app.uid, app.secret, site: 'https://example.com') }
  let(:auth_url) { client.auth_code.authorize_url(redirect_uri: app.redirect_uri) }
  let(:uri) { URI.parse(auth_url) }
  let(:uri_params) { CGI.parse(uri.query) }

  it 'oauth token flow' do
    # Rails test env does not keep request env
    Rails.application.env_config['REQUEST_URI'] = '/oauth/authorize'
    Rails.application.env_config['REMOTE_USER'] = 'djb44'
    page.driver.instance_variable_get(:@options)[:follow_redirects] = false
    visit oauth_authorization_url(client_id: uri_params['client_id'][0],
                                  redirect_uri: uri_params['redirect_uri'][0],
                                  response_type: uri_params['response_type'][0])
    # code = page.response_headers['Location'].split('=')[1]
    expect(page.status_code).to eq(302)
  end

  it 'bad client id' do
    Rails.application.env_config['REQUEST_URI'] = '/oauth/authorize'
    Rails.application.env_config['REMOTE_USER'] = 'djb44'
    page.driver.instance_variable_get(:@options)[:follow_redirects] = false
    visit oauth_authorization_url(client_id: 'bogus', redirect_uri: uri_params['redirect_uri'][0],
                                  response_type: uri_params['response_type'][0])
    expect(page.body).to include('OAuth authorization required')
  end

  it 'no REMOTE_USER' do
    Rails.application.env_config.delete('REMOTE_USER')
    Rails.application.env_config['REQUST_URI'] = '/oauth/authorize'
    page.driver.instance_variable_get(:@options)[:follow_redirects] = false
    visit oauth_authorization_url(client_id: uri_params['client_id'][0],
                                  redirect_uri: uri_params['redirect_uri'][0],
                                  response_type: uri_params['response_type'][0])
    expect(page.status_code).to eq(302)
    expect(page.response_headers['Location']).to include('webaccess.psu.edu')
  end
end
