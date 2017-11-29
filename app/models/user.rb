class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         omniauth_providers: [:google_oauth2]

  has_many :reservations

  def self.from_omniauth(acces_token)
    data = acces_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        email: data['email']  ,
        password: Devise.friendly_token[0,20]
      )
    end
    user
  end
end
