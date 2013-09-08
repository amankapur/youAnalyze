require 'net/http'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first
    
    stuff = JSON.parse(Net::HTTP.get(URI.parse('https://www.googleapis.com/youtube/v3/channels?part=id&mine=true&key=' + CONFIG[:google][:API_KEY] +'&access_token=' + access_token.credentials.token)))
    yt_id = stuff['items'].first['id']
    
    unless user && yt_id
        user = User.create(name: data["name"],
	    		   email: data["email"],
             google_uid: access_token["uid"],
             yt_id: yt_id,
	    		   password: Devise.friendly_token[0,20]
	    		  )
    end

    user
	end

end
