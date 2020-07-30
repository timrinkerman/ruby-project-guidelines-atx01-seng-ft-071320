class User < ActiveRecord::Base
    has_many :user_lyrics
    has_many :lyrics, through: :user_lyrics


    def self.create_user
        new_user = self.get_username
        new_user.password = self.set_password
        puts "\n" * 35
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
                puts "#{given_username.light_red.bold} is already taken. Please try to be original."
                 self.get_username 
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
        puts "\n" * 15
        given_password
    else
        puts "\n" * 15
        puts "Passwords didn't match. Try again".light_red
        self.set_password
    end
end


def self.login(username: find_user)
    user = self.get_username
    user.password = self.get_password
    @current_user = user
end


end