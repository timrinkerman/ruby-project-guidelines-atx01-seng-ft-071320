class User < ActiveRecord::Base
    has_many :user_lyrics
    has_many :lyrics, through: :user_lyrics

end