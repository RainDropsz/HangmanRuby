# frozen_string_literal: true

# Menus used in Hangman
module MainMenu
  def print_alphabet_two_lines
    puts "        #{@alphabet[0..@alphabet.length / 2 - 1].split('').join(' ')}"
    puts "        #{@alphabet[@alphabet.length / 2..-1].split('').join(' ')}"
  end

  def print_main_menu
    puts '    1 - New Game'
    puts '    2 - View Saved Games'

    choice = gets.chomp

    return if choice == '1'

    choice == '2' ? print_save_menu : print_main_menu
  end

  def save
    json_hash = { word: @word, alphabet: @alphabet, remaining: @remaining }

    File.open('save_file.json', 'a') do |file|
      file.puts JSON.generate(json_hash)
    end
  end

  def print_winner
    puts "    Congratulations! You guessed the word!\n"
  end

  def print_loser
    puts "    Sorry, you did not guess the word: #{@word}\n"
  end
end
