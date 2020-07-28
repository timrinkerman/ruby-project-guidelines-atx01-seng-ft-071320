class Lyric < ActiveRecord::Base

    has_many :lyrics
    has_many :users, through: :user_lyrics

    def self.get_lyrics(artist,song)
        response = Unirest.get # find by interpolating the artist and song into html #{artist}/#{song}/,
        headers:{
        #"X-RapidAPI-Host" => "numbersapi.p.rapidapi.com",
        #"X-RapidAPI-Key" => "03ad68a3d9msh715db69b24278b8p1c06acjsncb379bcf54f4"
        }
        lyric_info = Lyric.find_or_create_by(text: response.body["text"]) do |fact|
            lyric.song_title = response.body["#{song}"]
            lyric.artist = response.body["#{artist}"]
            lyric.genre = response.body[:key]
            lyric.lyrics = [:lyric]
            
            end
        lyric_info
    end


end

