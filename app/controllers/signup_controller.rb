class SignupController < ApplicationController

  # before_action :validates_signup1, only: :signup2         # signup2へ遷移する前にsignup1の入力内容にバリデーション
  # before_action :validates_signup2, only: :signup3         # signup3へ遷移する前にsignup2の入力内容にバリデーション
  # before_action :validates_signup3, only: :signup4         # signup4へ遷移する前にsignup3の入力内容にバリデーション

  def index
  end

  # 名前、パスワード等入力画面へ
  # サインインしている場合は商品一覧画面へリダイレクト。(サインアップ画面へ進ませない)
  def signup1
    redirect_to root_path if user_signed_in?
    @user = User.new(nickname: params[:nickname],email: params[:email])
    session[:user] = @user
  end


  # 電話番号入力画面へ
  # user_params、birthday_matchは最下部に記載あり
  # signup1で入力させた内容をsession内に一時保存
  def signup2                                              #signup1での入力内容をsessionで保持
    session[:nickname] = user_params[:nickname]
    session[:email] = user_params[:email]
    session[:password] = user_params[:password]
    session[:password_confirmation] = user_params[:password_confirmation]
    session[:birthday] = birthday_match
    session[:name_family_kanji] = user_params[:name_family_kanji]
    session[:name_first_kanji] = user_params[:name_first_kanji]
    session[:name_family_kana] = user_params[:name_family_kana]
    session[:name_first_kana] = user_params[:name_first_kana]
  end

  # 住所等入力画面へ
  # signup2で入力させた内容をsession内に一時保存
  def signup3
    session[:mobile_phone_number] = params[:mobile_phone_number]
  # パスワード欄の入力がない(nil)場合、パスワードを自動生成(Devise.friendly_token.first(7))してパスワードとパスワード(確認)に保存
  # これはomniauth用。omniauth(SNS認証経由で来た場合はパスワード欄が表示されないようにしてある為、必然的に未入力になる)
    if session[:password] == nil
      password = Devise.friendly_token.first(7)
      user = User.new(
        nickname: session[:nickname],
        email: session[:email],
        password: password,
        password_confirmation: password,
        birthday: session[:birthday],
        mobile_phone_number: session[:mobile_phone_number],
        name_family_kanji: session[:name_family_kanji],
        name_first_kanji: session[:name_first_kanji],
        name_family_kana: session[:name_family_kana],
        name_first_kana: session[:name_first_kana]
      )
    else
      user = User.new(
        nickname: session[:nickname],
        email: session[:email],
        password: session[:password],
        password_confirmation: session[:password_confirmation],
        birthday: session[:birthday],
        mobile_phone_number: session[:mobile_phone_number],
        name_family_kanji: session[:name_family_kanji],
        name_first_kanji: session[:name_first_kanji],
        name_family_kana: session[:name_family_kana],
        name_first_kana: session[:name_first_kana]
      )
    end

      if user.save
        sign_in User.find(user.id) unless user_signed_in?  #保存できたらサインインする→UserAddressにuser_idを入れられる
      else
        redirect_to signup_signup_index_path               #保存できなかったら最初の画面に戻る
      end
  end

  def signup4 
    gon.pk_key = ENV['PAYJP_TEST_PUBLIC_KEY']
    @user_address = UserAddress.create(user_address_params)
  end

# signup1での入力内容へのバリデーション
# newすることでバリデーションにかける
  def validates_signup1
    password = Devise.friendly_token.first(7)
      session[:nickname] = user_params[:nickname]
      session[:email] = user_params[:email]
      session[:password] =user_params[:password]
      session[:password_confirmation] = user_params[:password_confirmation]
      session[:birthday] = birthday_match
      session[:name_family_kanji] = user_params[:name_family_kanji]
      session[:name_first_kanji] = user_params[:name_first_kanji]
      session[:name_family_kana] = user_params[:name_family_kana]
      session[:name_first_kana] = user_params[:name_first_kana]
      @user = User.new(
        nickname: session[:nickname],
        email: session[:email],
        password: password,
        password_confirmation: password,
        birthday: session[:birthday],
        name_family_kanji: session[:name_family_kanji],
        name_first_kanji: session[:name_first_kanji],
        name_family_kana: session[:name_family_kana],
        name_first_kana: session[:name_first_kana]
        )
      # バリデーションにかかると画面は遷移せずもう一度入力するよう促す
        render '/signup/signup1' unless @user.valid?
  end
#signup2での入力内容へのバリデーション(signup1の入力も記載しないとバリデーションにかかってしまう為、再記載)
  def validates_signup2
    password = Devise.friendly_token.first(7)
    session[:mobile_phone_number] = user_params[:mobile_phone_number]
    @user = User.new(
      nickname: session[:nickname],
      email: session[:email],
      password: password,
      password_confirmation: password,
      birthday: session[:birthday],
      mobile_phone_number: session[:mobile_phone_number],
      name_family_kanji: session[:name_family_kanji],
      name_first_kanji: session[:name_first_kanji],
      name_family_kana: session[:name_family_kana],
      name_first_kana: session[:name_first_kana]
      )
    #バリデーションにかかると画面は遷移せずもう一度入力するよう促す
      render '/signup/signup2' unless @user.valid?
  end

#signup3での入力内容へのバリデーション
  def validates_signup3
    @user.user_address = UserAddress.new(
      send_name_family_kanji: session[:send_name_family_kanji],
      send_name_first_kanji: session[:send_name_first_kanji],
      send_name_family_kana: session[:send_name_family_kana],
      send_name_first_kana: session[:send_name_first_kana],
      zip: session[:zip],
      prefecture: session[:prefecture],
      city: session[:city],
      town: session[:town],
      apartment: session[:apartment],
      phone_number: session[:phone_number]
      )
    #バリデーションにかかると画面は遷移せずもう一度入力するよう促す
      render '/signup/signup3' unless @user.user_address.valid?
  end

  private

  def user_params
    params.require(:user).permit(
      :nickname,
      :email,
      :password,
      :password_confirmation,
      :mobile_phone_number,
      :name_family_kanji,
      :name_first_kanji,
      :name_family_kana,
      :name_first_kana,
      :birthday
  )
  end

  def user_address_params
    params.permit(
      :send_name_family_kanji,
      :send_name_first_kanji,
      :send_name_family_kana,
      :send_name_first_kana,
      :zip,
      :prefecture,
      :city,
      :town,
      # :apartment,
      :phone_number
    ).merge(user_id: current_user.id)
  end

  # def create_password                                   #パスワードが入力された場合は、そのパスワードを。入力されていない場合は自動生成し、返り値として返す。
  #   pass_rand = Devise.friendly_token.first(7)
  #   if params[:password].present?                       #sns認証を経由するとパスワード入力欄は表示されないため空欄になる。その場合に自動生成。
  #     return params[:password]
  #   else
  #     return pass_rand
  #   end
  # end


#f.date_selectで生成された情報をまとめて1つの情報にする。
  def birthday_match
    date = params[:birthday]

    #(1i)は年、(2i)は月、(3i)は日
    if date["birthday(1i)"].empty? && date["birthday(2i)"].empty? && date["birthday(3i)"].empty?
      return
    end
    
    #文字列としてインプットしたものを数値にして結合
    Date.new date["birthday(1i)"].to_i,date["birthday(2i)"].to_i,date["birthday(3i)"].to_i
  end

end