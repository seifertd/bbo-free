class ApplicationController < ActionController::Base
  def url_options
    super.except(:script_name)
  end
  def default_url_options
    { only_path: true }
  end
end
