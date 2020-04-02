# frozen_string_literal: true

if ENV['DD_AGENT_HOST']
  require 'ddtrace'
  Datadog.configure do |c|
    # TODO: do more configureation here.
    c.use :rails
    c.env = 'dev'
  end
end
