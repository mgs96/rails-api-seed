class Users::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  
  def redirect_callbacks
    super 
    # some logic here
  end

  # def omniauth_success
  #   super do |resource|
  #     if omniauth_window_type.present? # auth requested from angular
  #       sign_in resource
  #     else # auth requested from backend standalone
  #       # remember_me resource
  #       sign_in_and_redirect resource and return
  #     end
  #   end
  # end

  # def google_oauth2
  #     # You need to implement the method below in your model (e.g. app/models/user.rb)
  #     @user = User.from_omniauth(request.env['omniauth.auth'])

  #     if @user.persisted?
  #       flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
  #       sign_in_and_redirect @user, event: :authentication
  #     else
  #       session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
  #       redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
  #     end
  # end
end