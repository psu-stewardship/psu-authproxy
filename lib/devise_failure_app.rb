# frozen_string_literal: true

class RedirectToWebaccessFailure < Devise::FailureApp
  def redirect_url
    # TODO redirect this to the right place
    referer = request.params[:redirect_uri]
    # referer = request.params.redirect_uri || request.referer
    request.headers["REMOTE_USER"] = "abc1245"
    request.env["REQUEST_URI"]
    # "https://google.com"
    #   WebAccess.new(request.env['ORIGINAL_FULLPATH'] || '').login_url
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
