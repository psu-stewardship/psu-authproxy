# frozen_string_literal: true

module FactoryBotHelpers
  def self.generate_access_id
    alphabet = ('a'..'z').to_a

    format("#{alphabet.sample(3).join}#{rand(100)}")
  end
end
