class Controller 

require 'uri'
require 'net/http'
require 'openssl'
#require 'awesome_print'
require 'json'
require 'launchy'
require 'colorize'



require 'readline'


def intro                                      
    answer = PROMPT.yes?("\n\n\nAre you a new user?") do |q|
       q.suffix 'Y/N'
     end
   if answer 
    about 
   else
  
    login        
   end
end   

def about
   
    puts "\sSoundtrack2Mylife will allow you to keep a journal of all the songs who sent you on a feels trip".light_cyan

    sign_up = PROMPT.select("SignUP or Exit", %w(SignUP Exit))
    case sign_up
    when "SignUP"
        @@current_user = User.create_user 
                   
        answer = PROMPT.yes?("We can find lyrics from almost any song.\n\s Would you like to try with your favorite track?\n\n\n".light_cyan) do |q|            
            q.suffix 'Y/N'
        end
            if answer
               
                # artist = PROMPT.ask("Who is the artist?")
                # song_title = PROMPT.ask("What is the name of the song?")
                lyric = Lyric.new_lyrics(@@current_user)
                # Controller.display(@@current_user.lyrics)
                save_lyric = PROMPT.select("You can save this awesome track or open that sucker up right now and vibe ", %W(Save Listen Main))
                case save_lyric
                when "Save"                        
                    # UserLyric.save_lyrics(@@current_user.lyrics)
                  puts "We'll add that to your list"
                    Controller.main
                when "Main"
                    Controller.main
                when "Listen"
                    # Lyrics.all.select.open(urls_for_song)
                end
            else
                Controller.main
            end

end 
end

def login

    login_or_exit = PROMPT.select("", %w(Login Exit))
    case login_or_exit
    when "Login"
        
        find_user = PROMPT.ask("What is your username?".light_cyan, required: true)
        @@current_user = User.find_by(username: find_user)
        if @@current_user == nil
            puts "User not found".light_red
            puts "Please try again!"
            self.login
        end
        enter_password = PROMPT.mask('password:', echo: true,required: true)
        if enter_password == @@current_user.password
            @@current_user
            Controller.main
        else
       
            puts "That aint it chief.".light_red
            puts "Please try again!".light_yellow
            login 
        end
    else "Exit"
        Controller.New 
             
    end       
end

def self.main 

if @@current_user == nil
    puts "You have to be logged in to use soundtrack :("
    Controller.login
else
puts "Hey #{@@current_user.username.light_yellow.bold}!"
puts "\n" 

#menu function
menu_selection = PROMPT.select("Select from the following options?", %w(TheSoundTrack2MYLife AddAVibe RandomVibes RandomArtistLyrics EditMyInfo LogOut))
case menu_selection
when "TheSoundTrack2MYLife"
    menu_selection = PROMPT.select('Select from the following options.', %w(ShowAll DeleteAll Main))
    case menu_selection
    when "ShowAll"
        Controller.display(@@current_user.lyrics)
        new_menu_selection = PROMPT.select('Back', %w( Back))
        case new_menu_selection
        when "Back"
        Controller.main
        end
    when "DeleteAll"
        are_you_sure = PROMPT.yes?('Are you sure you want to delete all?') do |q|
        q.suffix 'Y/N'
        end
        if are_you_sure
        @@current_user.facts.delete_all
        Controller.main
        else
        Controller.main
        end
    when "Main"
        Controller.main
    end
when "AddAVibe"
    new_lyrics = Lyric.new_lyrics(@@current_user)
    
    save_lyric = PROMPT.select("You can save this awesome track or listen to it right now!", %W(Save Listen Main))
    case save_lyric
    when "Listen"
    puts "\nPress 1 to open lyrics in browser, or press 2 to listen on YouTube.".colorize(:light_blue)
    
    user_input = gets.chomp
    if user_input == "1"
        Launchy.open(@@current_user.lyrics.select {|song| song.lyrics == new_lyrics})
        # Launchy.open(@@current_user.lyrics.find_by(lyrics:
    elsif user_input == "2"
        Launchy.open(urls_for_song)
    end
    when "Main"
    Controller.main    
    when "Save"                       
    puts "sweet we'll add that to your diary"
end
    Controller.main
when "RandomVibes"
    puts "Coming Soon...."
    back = PROMPT.select("", %W(Main))
    case back     
    when "Main"
        Controller.main
    end
when "RandomArtistLyrics"
    puts "Coming Soon...."
    back = PROMPT.select("", %W(Main))
    case back     
    when "Main"
        Controller.main
    end
when "EditMyInfo"
    edit_prompt = PROMPT.select("What would you like to change?", %W(Username Password))
    case edit_prompt
    when "Username"
        new_username = PROMPT.ask("Type in your new Username:")
        while new_username == nil
            new_username =  PROMPT.ask("Type in your new Username.")
        end
        @@current_user.username = new_username
        @@current_user.save
        puts "Your username has been changed to #{@@current_user.username}"
        main
    when "Password"
        given_password = PROMPT.mask("What do you want your new password to be?".light_green, required: true) do |q|
        q.validate(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)
        q.messages[:valid?] = 'Your passowrd must be at least 8 characters and include one number and one letter...just like everyother site....'
    end
    confirm_password = PROMPT.mask("Please confirm that password".light_green, required: true)
    if given_password == confirm_password
        @@current_user.password = given_password
        @@current_user.save
        puts "Your password has been changed."
        intro
    end
    end

when "LogOut"
    puts "See you soon!"
end


end
end


#return object associated with the lyric id
#make when object  is == userlyric.lyric_id appear on the screen
#that should be the lyric instance attached to the user
#info should include the artist of the song
#link to the lyrics
#link to youtube


def self.display(lyrics_array)
    lyrics_array.each do |instance|
    puts "Song: ".red, "#{instance.song_title} ".light_green, "by: ".white, "#{instance.artist} ".light_green, "lyrics: ".white,  "#{instance.lyrics} \n".light_blue
  #binding.pry
    end
end

end