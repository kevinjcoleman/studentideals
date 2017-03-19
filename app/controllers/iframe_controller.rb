class IframeController < ApplicationController
  after_filter :allow_iframe

  def search_box
    render layout: 'iframeable'
  end

  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end
end
