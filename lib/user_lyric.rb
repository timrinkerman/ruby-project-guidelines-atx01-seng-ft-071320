class UserLyric < ActiveRecord::Base
    belongs_to :user
    belongs_to :lyric

    def self.save_lyrics(user_id, lyric_id)
        new_save = UserLyric.new(user_id: user_id, lyric_id: lyric_id)
        new_save.save

end
end