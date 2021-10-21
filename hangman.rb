
require 'colorize'
require 'json'

class Hangman

    $dictionary_file =  File.readlines(("word_list.txt"))
    @@word_cpt = 0
 
    
    def initialize() 
        @word_to_find = generate_word($dictionary_file)
        @cpt_try = 15
    end


    def start
        display_home_screen()
    end

    private 
    def display_home_screen()
        puts `clear`
        puts "welcome to Hangman game"
        puts " "
        puts "choice between: "
        puts "1 - for new game"
        puts "2 - saved game "

        goodAnswer = false
        choice = ""

        while !goodAnswer do
            choice = gets.chomp

            if (choice == "1" || choice == "2")
                break
            end    
            puts "please choice do your choice"
          end

        if choice == "1"
            play(@word_to_find, @cpt_try)
        else
            file_save = File.read('save.json')
            data_hash = JSON.parse(file_save)

            if (data_hash['word_to_find']  == "")
                puts "No game saved"
            else
                play(data_hash['word_to_find'], data_hash['cpt_try'], data_hash['letter_choiced_arr'], data_hash['finding_words'])
            end
        end
        
    end

    private
    def generate_word(words)
        filter_list = []
        words.each do |word| 
            if word.length >= 5  && word.length <= 12
                filter_list << word.strip().downcase
                @@word_cpt += 1
            end
        end

        return filter_list[rand(@@word_cpt)]
    end

    private
    def play(word_to_find, cpt_try, letter_choiced_arr = [], finding_words = Array.new(word_to_find.length, "_"))

        puts `clear`

        loop do
            puts "you have #{cpt_try} chance for find the word"
            puts "you already choiced : #{letter_choiced_arr.join(", ")}"
            puts finding_words.join(" ")
            puts ""    
            puts ""    
            puts "choice a letter for play || if you wnant to save the game, enter \"save\" "   
            
            letter = gets.chomp.downcase       

            if letter != "save"
                    if  letter_choiced_arr.include?(letter.downcase)
                        puts `clear`
                        puts "------------------------------------------".red
                        puts "this letter (#{letter}) already choiced !".red
                        puts "------------------------------------------".red
                        sleep(2)
                    else
                        letter_choiced_arr.push(letter.downcase)
                    end
        
        
                    index_arr = (0 ... word_to_find.length).find_all { |i| word_to_find[i,1] == letter }
                    
                    if !index_arr.empty?
                        index_arr.each do |index|
                            finding_words[index] = letter
                        end
                    end
                    
                    cpt_try -= 1
        
                    if cpt_try == 0 
                        gameover()
                        sleep(1)
                        break
                    elsif !finding_words.include?("_")   
                        gamewin(word_to_find)
                        sleep(1)
                        break
                    end 
                puts `clear`
            else
                file_save = File.read('save.json')
                data_hash = JSON.parse(file_save)

                data_hash['word_to_find'] = word_to_find
                data_hash['cpt_try'] = cpt_try
                data_hash['letter_choiced_arr'] = letter_choiced_arr
                data_hash['finding_words'] = finding_words
                File.write('save.json', JSON.dump(data_hash))
                puts `clear`
                puts "------------------------------------------".red
                puts "your game saved with success !".red
                puts "see you !"
                puts "------------------------------------------".red
                break
            end
        end
    end
end

private
def gameover()
    puts `clear`
    puts "YOU LOOSE !".red
end

private 
def gamewin(world)
    puts `clear`
    puts "feliciation, you guess the world: #{world}".red
end



test = Hangman.new()
test.start 
  
     