class UserLyrics < ActiveRecord::Migration[5.0]
    def change 
        create_table :user_lyrics do |t|
          t.integer :user_id
          t.integer :lyric_id
        end
    end
end     