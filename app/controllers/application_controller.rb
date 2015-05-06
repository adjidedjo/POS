class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception. For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resources)
    if resources.role == "admin"
      root_path
    else
      unless resources.channel_customer.nil?
        if resources.channel_customer.exhibition_stock_items.blank?
          import_intransit_channel_customers_path
        elsif resources.channel_customer.exhibition_stock_items.where(checked_in: true).blank?
          item_receipts_receipt_path
        else
          root_path
        end
      end
    end
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :admin
    devise_parameter_sanitizer.for(:sign_in).push(:username)
  end
end