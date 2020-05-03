class Hangman
  require 'json'

  def initialize
    wordbank = File.readlines "5desk.txt"
    wordbank = wordbank.select  { |word| word.length.between?(5,12) }
    @word = wordbank[rand(wordbank.length)].chomp

    @alphabet = "abcdefghijklmnopqrstuvwxyz"
    @masked_word = @word.gsub(/[#{@alphabet}]/i, "_").split("").join(" ")
    @remaining_guesses = 10
    guess = ""

    puts "    Let's play Hangman!"

    get_new_or_saved

    print_word


    until winner? || @remaining_guesses == 0 || guess == "save"
      guess = get_guess_or_save
      guess == "save" ? break : remove_guess_from_alphabet(guess) 

      @remaining_guesses -= 1 
      print_word

    end

    guess == "save" ? 
    save :   
    winner? ? print_winner : print_loser
  end

  def get_new_or_saved
    puts "    1 - New Game"
    puts "    2 - View Saved Games"

    choice = gets.chomp

    if choice == "2" 
      view_saved_games
    elsif choice == "1"
      return
    else
      puts "    Please choose a number:"
      get_new_or_saved
    end
  end

  def view_saved_games
    if File.zero?("save_file.json") || ! File.exist?("save_file.json")
      puts "    There are no saved games. Starting new game. \n\n"
      return
    end

    puts "    Please choose a game to load."
    puts "    Or to delete a game, type del followed by the number (eg: del 1)"
    
    save_states = File.readlines "save_file.json"
    save_states.each_with_index do |line, index|
      hash = JSON.parse(line)
      puts "    " + (index+1).to_s + " - " + 
           print_masked_word(hash["word"], hash["alphabet"]) + 
           " Remaining Guesses: " + hash["remaining_guesses"].to_s
    end


    option = gets.chomp
    if option.to_i.between?(1, save_states.length)
      @word =              JSON.parse(save_states[option.to_i - 1])["word"]
      @alphabet =          JSON.parse(save_states[option.to_i - 1])["alphabet"]
      @remaining_guesses = JSON.parse(save_states[option.to_i - 1])["remaining_guesses"]

      return

    elsif option =~ /del [0-9]/
      save_states.slice!(option.slice(4..-1).to_i - 1)
      puts "Line #{option.slice(4..-1)} has been deleted"
      File.open("save_file.json",'w') do |file|
        file.puts save_states
      end
    else
      puts "    Sorry, that is not a valid option."     
    end

    get_new_or_saved
  end

  def print_masked_word(word, alphabet)
    masked_word = word.gsub(/[#{alphabet}]/i, "_").split("").join(" ").ljust(20)
  end

  def print_word
    @masked_word = @word.gsub(/[#{@alphabet}]/i, "_").split("").join(" ")
    puts "          #{@masked_word}       Remaining Guesses: #{@remaining_guesses}"    
  end

  def get_guess_or_save
    while true
      puts "    Please guess a letter: #{@alphabet.split("").join(" ")}"
      puts "    Or type 'save' to save the game"
      guess = gets.chomp.downcase
      break if guess =~ /[a-z]/ && @alphabet.include?(guess) || guess == "save"
    end
    guess
  end

  def remove_guess_from_alphabet(guess)
    @alphabet.delete!(guess)
  end

  def winner?
    ! @masked_word.include?("_") 
  end

  def print_winner
    puts "Congratulations! You guessed the word!" 
  end

  def print_loser
    puts "Sorry, you did not guess the word: #{@word}"
  end

  def save
    json_hash = {word: @word, alphabet: @alphabet, remaining_guesses: @remaining_guesses}

    File.open("save_file.json",'a') do |file|
      file.puts JSON.generate(json_hash)
    end

  end

end



Hangman.new

