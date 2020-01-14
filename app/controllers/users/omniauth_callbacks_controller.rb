class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    callback_for(:facebook)
  end

  def google_oauth2
    callback_for(:google)
  end

  # providerはfacebookとgoogleを引数としてとったもの
  def callback_for(provider)
    #omniauth.authには環境変数が入る
    @user = User.find_oauth(request.env["omniauth.auth"])
    #userはDBに保存されているか？されていたら if 以下。されていなかったら unless 以下を実行。
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication  #signinして@user(user_root_pathを優先)へリダイレクト
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
    else 
      if user_signed_in?
        redirect_to root_path
      else
        session["devise.#{provider}_data"] = request.env["omniauth.auth"]
        render template: "signup/signup1"
      end
    end
  end

  def failure
    redirect_to items_path
  end

end


# def facebook
#   # You need to implement the method below in your model (e.g. app/models/user.rb)
#   @user = User.from_omniauth(request.env["omniauth.auth"])

#   if @user.persisted?
#     sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
#     set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
#   else
#     session["devise.facebook_data"] = request.env["omniauth.auth"]
#     redirect_to new_user_registration_url
#   end
# end

# def failure
#   redirect_to root_path
# end




# def google_oauth2
#   @user = User.find_for_google(request.env['omniauth.auth'])

#   if @user.persisted?
#     flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
#     sign_in_and_redirect @user, event: :authentication
#   else
#     session['devise.google_data'] = request.env['omniauth.auth']
#     redirect_to new_user_registration_url
#   end
# end