# frozen_string_literal: true

require Rails.root.join('spec/support/factory_bot_helpers')

FactoryBot.define do
  factory :ldap_user do
    skip_create

    transient do
      groups { Array.new(3) { "cn=up.libraries.#{Faker::Currency.code.downcase},dc=psu,dc=edu" } }
      surname { Faker::Name.last_name }
      last_name { surname }
      given_name { Faker::Name.first_name }
      first_name { given_name }
      primary_affiliation { 'STAFF' }
      access_id { FactoryBotHelpers.generate_access_id }
      admin_area { 'University Libraries' }
    end

    initialize_with do
      # @note LdapUser takes a Net::LDAP::Entry for an argument. We can mock it by using a hash.
      new(
        psmemberof: groups.map(&:dup),
        sn: [surname],
        givenname: [given_name],
        edupersonprimaryaffiliation: [primary_affiliation],
        uid: [access_id],
        psadminarea: [admin_area]
      )
    end

    trait :is_admin do
      groups { [User::DEFAULT_ADMIN_UMG] }
    end
  end
end
