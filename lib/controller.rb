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
    yes_or_no = PROMPT.yes?("\n\n\nAre you a new user?") do |q|
       q.suffix 'Y/N'
     end
   if yes_or_no
    about 
   else
    puts "\n" * 35
    login        
   end
end   

def about
    puts "\n" * 15
    puts "\sSoundtrack2Mylife will allow you to keep a journal of all the songs who sent you on a feels trip".light_cyan
    puts "\n" * 5
    sign_up = PROMPT.select("SignUP or Exit", %w(SignUP Exit))
    case sign_up
    when "SignUP"
        @@current_user = User.create_user 
        puts "\n" * 35           
        yes_or_no = PROMPT.yes?("We can find lyrics from almost any song.\n\s Would you like to try with your favorite track?\n\n\n".light_cyan) do |q|            
            q.suffix 'Y/N'
        end
            if yes_or_no
                puts "\n" * 35
                artist = PROMPT.ask("Who is the artist?")
                song_title = PROMPT.ask("What is the name of the song?")
                lyric = Lyric.new.find_song(artist, song_title)
                Controller.display(lyric)
                save_lyric = PROMPT.select("You can save this awesome track", %W(Save Main))
                case save_lyric
                when "Save"                        
                    UserLyric.save_lyrics(@@current_user.id,lyric[0].id)
                    Controller.main
                else "Main"
                    Controller.main
                end
            else
                Controller.main
            end

    #     Controller.main
    # else "Exit"
    #     Controller.quit
    # end
end 
end

def login

    login_or_exit = PROMPT.select("", %w(Login Exit))
    case login_or_exit
    when "Login"
        puts "\n" * 35
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
            main
        else
            puts "\n" * 35
            puts "Access denied.".light_red
            puts "Please try again!".light_yellow
            login 
        end
    else "Exit"
        Controller.New 
             
    end       
end

def main 
puts "\n" * 30
if @@current_user == nil
    puts "You have to be logged in to use IceBreaker :("
    Controller.login
else
puts "Hello #{@@current_user.username.light_yellow.bold}!"
puts "\n" 
menu_selection = PROMPT.select("Select from the following options?", %w(TheSoundTrack2MYLife AddAVibe RandomVibes RandomArtistLyrics EditMyInfo LogOut))
case menu_selection
when "TheSoundTrack2MYLife"
    menu_selection = PROMPT.select('Select from the following options.', %w(ShowAll DeleteAll Main))
    case menu_selection
    when "ShowAll"
        puts "\n" * 35
        Controller.display(@@current_user.user_lyrics)
        menu_selection = PROMPT.select('Select from the following options.', %w( Back))
        case menu_selection
        when "Back"
        main
        end
    when "DeleteAll"
        are_you_sure = PROMPT.yes?('Are you sure you want to delete all?') do |q|
        q.suffix 'Y/N'
        end
        if are_you_sure
        @@current_user.facts.delete_all
        main
        else
        main
        end
    when "Main"
        main
    end
when "AddAVibe"
    puts "\n" * 35
    new_lyrics = Lyric.new_lyrics
    
    binding.pry
    
    # artist = PROMPT.ask("Who is the artist?")
    # while artist == nil 
    #     artist = PROMPT.ask("Who is the artist?")
    # end
    # song_title = PROMPT.ask("What is the name of the song?")
    # lyric = Lyric.new_lyrics(artist, song_title)
    #Controller.display(lyric)
    save_lyric = PROMPT.select("You can save this awesome track or listen to it right now!", %W(Save Listen Main))
    case save_lyric
    when "Listen"
    puts "\nPress 1 to open lyrics in browser, or press 2 to listen on YouTube.".colorize(:light_blue)
    user_input = gets.chomp
    if user_input == "1"
        Launchy.open(genius_url_lyrics)
    elsif user_input == "2"
        Launchy.open(urls_for_song)
    end
    when "Save"                        
    
    
    
    UserLyric.save_lyrics(@@current_user.id,new_lyrics.id)
    main
    when "Main"
    main
    end
end
end
end
end