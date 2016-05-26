class Registrations::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  before_filter :authenticate_admin!

  def new
    if admin_signed_in?
      super
    else
      warning_flash
      redirect_to root_path
    end
   end
  
  def create
    if admin_signed_in?
      super
    else
      warning_flash
      redirect_to root_path
    end
   end

  def edit
    if admin_signed_in?
      super
    else
      warning_flash
      redirect_to root_path
    end
   end

  def update
    if admin_signed_in?
      super
    else
      warning_flash
      redirect_to root_path
    end
   end

  def destroy
    if admin_signed_in?
      super
    else
      warning_flash
      redirect_to root_path
    end
   end

   private
    def warning_flash
      flash[:danger] = "You can't access that page."
    end


  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
