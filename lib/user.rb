class User < ActiveRecord::Base
    
    has_many :user_lyrics
    has_many :lyrics, through: :user_lyrics


    def self.create_user
        new_user = self.get_username
        new_user.password = self.set_password
      
        new_user.save
        @@current_user = new_user
    end  
    
    def self.get_username
        given_username = PROMPT.ask("What do you want your new User Name to be?", required: true)
        confirm_username = PROMPT.yes?("#{given_username.light_green.bold} is what you entered. Are you sure?") do |q|
          q.suffix 'Y/N'
        end
        if confirm_username
           if User.find_by(username: given_username) == nil
                User.create(username: given_username)           
            else
                puts "#{given_username.light_red.bold} is already taken but whatever just make a new password."
                User.create(username: given_username)  
            end
        else 
            self.get_username
        end
    end


def self.set_password 
    given_password = PROMPT.mask("What do you want your password to be?".light_green, required: true) do |q|
        q.validate(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)
        q.messages[:valid?] = 'Your passowrd must be at least 8 characters and include one number and one letter...just like everyother site....'
    end 
    confirm_password = PROMPT.mask("Please confirm that password".light_green, required: true)       
    if given_password == confirm_password
       
        given_password
    else
        puts "Passwords didn't match. Try again".light_red
        self.set_password
    end
end


def self.login(username: find_user)
    user = self.get_username
    user.password = self.get_password
    @@current_user = user
end


def get_lyrics
    UserLyric.all.select do |save| 
        result = save.user_id == self.id
        Lyric.all.map do |song| 
        song.id == get_lyrics.lyric_id
        end
    end
end

def get_lyrics_actual
    Lyric.all.map {|song| song.id == get_lyrics.lyric_id}

end
end