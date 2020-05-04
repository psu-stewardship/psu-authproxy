# frozen_string_literal: true

require 'base64'

Doorkeeper::OpenidConnect.configure do
  issuer ENV['OIDC_ISSUER']

  signing_key Base64.decode64(ENV['OIDC_SIGNING_KEY'])

  subject_types_supported [:public]

  resource_owner_from_access_token do |access_token|
    # Example implementation:
    User.find_by(id: access_token.resource_owner_id)
  end

  auth_time_from_resource_owner(&:current_sign_in_at)

  reauthenticate_resource_owner do |resource_owner, return_to|
    # Example implementation:
    store_location_for resource_owner, return_to
    sign_out resource_owner
    redirect_to new_user_session_url
  end

  subject do |resource_owner, _application|
    # Example implementation:
    resource_owner.access_id

    # or if you need pairwise subject identifier, implement like below:
    # Digest::SHA256.hexdigest("#{resource_owner.id}#{URI.parse(application.redirect_uri).host}#{'your_secret_salt'}")
  end

  # Protocol to use when generating URIs for the discovery endpoint,
  # for example if you also use HTTPS in development
  protocol do
    :https
  end

  # Expiration time on or after which the ID Token MUST NOT be accepted for processing. (default 120 seconds).
  # expiration 600

  # Example claims:
  claims do

    claim :sub do | resource_owner|
      resource_owner.access_id
    end

    normal_claim :email, response: [:id_token, :user_info] do |resource_owner|
      resource_owner.email
    end

    claim :given_name do | resource_owner|
      resource_owner.given_name
    end

    claim :family_name do | resource_owner|
      resource_owner.surname
    end

    normal_claim :name do | resource_owner|
      "#{resource_owner.given_name} #{resource_owner.surname}"
    end

    claim :groups, response: [:id_token, :user_info] do |resource_owner|
      resource_owner.groups
    end
  end
end
