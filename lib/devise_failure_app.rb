# frozen_string_literal: true

class RedirectToWebaccessFailure < Devise::FailureApp
  def redirect_url
    binding.pry
    if request.env['REQUEST_URI'].include?("/oauth/applications")
      "https://webaccess.psu.edu/?cosign-#{request.host}&https://#{request.host}/#{request.env['REQUEST_URI']}"
    else
      "https://webaccess.psu.edu/?cosign-#{request.host}&https://#{request.host}/oauth/authorize?client_id=#{request.params[:client_id]}&redirect_uri=#{request.params[:redirect_uri]}&response_type=#{request.params[:response_type]}&state=#{request.params[:state]}&scope=#{request.params[:scope]}"
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  # Overriding, so that we don't set the flash[:alert] with the unauthenticated message
  def redirect
    store_location!
    if flash[:timedout] && flash[:alert]
      flash.keep(:timedout)
      flash.keep(:alert)
    end
    redirect_to redirect_url
  end
end
