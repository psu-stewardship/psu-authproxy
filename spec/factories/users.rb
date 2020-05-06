# frozen_string_literal: true

require Rails.root.join('spec/support/factory_bot_helpers')

FactoryBot.define do
  factory :user do
    access_id { FactoryBotHelpers.generate_access_id }
    email { "#{access_id}@psu.edu" }
    is_admin { false }
    password { SecureRandom.uuid }
    password_confirmation { password }

    trait :admin do
      is_admin { true }
    end
  end
end
