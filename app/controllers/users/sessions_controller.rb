class Users::SessionsController < Devise::SessionsController
before_filter :configure_sign_in_params, only: [:create]
before_filter :get_user, only: [:destroy]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
    UserTracing.create :user_id => @user.id, :action => 0, :ip => request.ip
  end

  protected

  # You can put the params you want to permit in the empty array.

  def get_user
    @user = current_user
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :attribute
  end
end
