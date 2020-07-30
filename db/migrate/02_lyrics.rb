class Lyrics < ActiveRecord::Migration[5.0]
    def change 
        create_table :lyrics do |t|
          t.string :song_title
          t.string :artist
          t.string :genre
          t.text :lyrics
          t.string :music_video

        end
    end
end