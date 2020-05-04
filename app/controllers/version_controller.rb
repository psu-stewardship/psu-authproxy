# frozen_string_literal: true

class VersionController < ApplicationController
  def show
    version = if ENV['APP_VERSION']
                { "version": ENV['APP_VERSION'] }
              else
                { "version": 'No Version Given' }
              end
    render json: version
  end
end
