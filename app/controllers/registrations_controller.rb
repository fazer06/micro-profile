# http://jacopretorius.net/2014/03/adding-custom-fields-to-your-devise-user-model-in-rails-4.html
class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:user_name, :business_name, :type, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:user_name, :business_name, :type, :email, :password, :password_confirmation, :current_password)
  end
end