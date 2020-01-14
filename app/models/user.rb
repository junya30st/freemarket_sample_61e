class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_one  :user_address
  has_many :cards
  has_many :sns_credentials, dependent: :destroy

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

# SNS認証時に使用(サインアップ時にはsnscredentialテーブルには情報が記載されない。サインイン時に初めて作成される)
  #find_oauthはomniauth_callbacks_controllerと対応。userを返り値として返してcallback_for内で使用する
    def self.find_oauth(auth)
      uid = auth.uid  #uidとはsns内でのidのようなもの？アカウントがあるかどうかを判断？
      provider = auth.provider  #providerはこの場合Facebookもしくはgoogle
      snscredential = SnsCredential.where(uid: uid, provider: provider).first #SnsCredentialテーブル内に上記の情報があるか確認。あれば変数が作成される。

      if snscredential.present?
      #snscredentialのuser_idがuserへ
        user = User.where(id: snscredential.user_id).first

      else
      #snsに登録しているemailと一致するemailを持つユーザーをusersテーブル内から探す
        user = User.where(email: auth.info.email).first

        # usersテーブル内に情報があればif以下。なければelse
        if user.present? # usersテーブル内に情報があればsns_credentialsテーブルに情報を作成
          SnsCredential.create(
            uid: uid,
            provider: provider,
            user_id: user.id
            )
        else
          user = User.create(
            nickname: auth.info.name,
            email:    auth.info.email,
          )

          SnsCredential.create(
            uid: uid,
            provider: provider,
            user_id: user.id
            )
        end
      end
      return user
    end
  
  has_many :items
  has_many :likes
  
  validates :nickname,:email,:password,:password_confirmation,:name_family_kanji,:name_first_kanji,:name_family_kana,:name_first_kana,:mobile_phone_number,:birthday, presence: true
  validates :password,length: {minimum:7}
  validates :mobile_phone_number,uniqueness: true, length: {minimum:11}
end
