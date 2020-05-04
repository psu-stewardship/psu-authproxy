class VersionController < ApplicationController
    def show
        if ENV['APP_VERSION']
            version = {"version": ENV['APP_VERSION']}
        else
            version = {"version": "No Version Given"}
        end
        render json: version
    end
end
