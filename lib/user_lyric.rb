class UserLyric < ActiveRecord::Base
    belongs_to :users
    belongs_to :lyrics

    def self.save_lyrics(user_id, lyric_id)
        save_lyrics = user_lyric.new(user_id: user_id, lyric_id: lyric_id)
        save_lyrics.save

end
end