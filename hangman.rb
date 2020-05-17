# frozen_string_literal: true

# Hangman
class Hangman
  require 'json'
  require_relative 'main_menu'
  require_relative 'save_menu'

  include MainMenu
  include SaveMenu

  def initialize
    @word = pick_secret_word
    @alphabet = 'abcdefghijklmnopqrstuvwxyz'
    @masked_word = @word.gsub(/[#{@alphabet}]/i, '_').split('').join(' ')
    @remaining = 10

    puts "    Let's play Hangman!"

    print_main_menu
    play_game
    Hangman.new
  end

  def gets_guess_or_save
    while true
      puts '    Please guess a letter:'
      print_alphabet_two_lines
      puts "    Or type 'save' to save the game"
      guess = gets.chomp.downcase
      break if guess =~ /[a-z]/ && @alphabet.include?(guess) || guess == 'save'
    end
    guess
  end

  def pick_secret_word
    wordbank = File.readlines '5desk.txt'
    wordbank = wordbank.select { |word| word.strip!.length.between?(5, 12) }
    wordbank[rand(wordbank.length)].chomp
  end

  def play_game
    print_word_and_remaining

    until winner? || @remaining.zero?
      guess = gets_guess_or_save
      return save if guess.downcase == 'save'

      remove_guess_from_alphabet(guess)

      @remaining -= 1
      print_word_and_remaining
    end

    winner? ? print_winner : print_loser
  end

  def print_word_and_remaining
    @masked_word = @word.gsub(/[#{@alphabet}]/i, '_').split('').join(' ')
    puts "    #{@masked_word}    Remaining Tries: #{@remaining}"
  end

  def remove_guess_from_alphabet(guess)
    @alphabet = @alphabet.delete(guess)
  end

  def winner?
    !@masked_word.include?('_')
  end
end

Hangman.new
