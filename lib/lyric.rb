
class Lyric < ActiveRecord::Base

    has_many :lyrics
    has_many :users, through: :user_lyrics


    def self.new_lyrics
    new_song = self.find_song
        #I still can not seem to create a new lyric instance
    #     Lyric.create(artist: artist, song_title: song_title)
    new_song 
   @@current_song
    end 


#searches artist and song, then returns the response body
def self.search_artist_song(artist, song_title)
 
        url = URI("https://genius.p.rapidapi.com/search?q=#{artist}/#{song_title}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'genius.p.rapidapi.com'
    request["x-rapidapi-key"] = '3db2392555msh7d2126664c21614p11f436jsna30c75016df0'
    response = http.request(request)
    response.body
end
#searches the song path by id, then returns the response body
def self.seach_song_by_id(song_path)
    url = URI("https://genius.p.rapidapi.com#{song_path}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'genius.p.rapidapi.com'
    request["x-rapidapi-key"] = '3db2392555msh7d2126664c21614p11f436jsna30c75016df0'
    response = http.request(request)
    response.body
end
#calls the two methods above, and returns the parsed data
def self.find_song
    
    #latest update --> if fails move to controller
    artist = PROMPT.ask("Who is the artist?")
    while artist == nil 
        artist = PROMPT.ask("Who is the artist?")
    end
    song_title = PROMPT.ask("What is the name of the song?") 
    jeff = Lyric.create(artist: artist, song_title: song_title)
    jeff.save
    @@current_song = jeff
    
    #need to save that and have it be accessable
    
    
    parsed = JSON.parse(search_artist_song(artist, song_title))
    get_song_path = parsed["response"]["hits"][0]["result"]["api_path"]
    search_song_id = JSON.parse(seach_song_by_id(get_song_path))
    urls_for_song = search_song_id["response"]["song"]["media"]
    puts song_artist_title = parsed["response"]["hits"][0]["result"]["full_title"]
    puts genius_url_lyrics = parsed["response"]["hits"][0]["result"]["url"]
    urls_for_song.each do |links|
        puts urls_for_song = links["url"]
    
    end
 
    #lyrics_request = Lyric.find_or_create_by(text: parsed) do |lyric|
    #    lyric.text = genius_url_lyrics
    #    lyric.song_title = song_artist_title
    #end

end
end
