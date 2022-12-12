class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception. For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_device_type

  private

  def set_device_type
    request.variant = :phone if browser.mobile?
    request.variant = :tablet if browser.tablet?
  end

  protected

  def after_sign_in_path_for(resources)
    if resources.role == "admin"
      root_path
    else
      unless resources.channel_customer.nil?
        item_receipts_receipt_path
      else
        root_path
      end
    end
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :admin
    devise_parameter_sanitizer.for(:sign_in).push(:username)
  end
end
