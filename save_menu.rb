# frozen_string_literal: true

# Methods related to Hangman Save Menu
module SaveMenu
  def delete_line(option, save_states)
    if valid_save_line?(option, save_states.length)
      line_number = option.slice(4..-1).to_i
      save_states.slice!(line_number - 1)
      puts "Line #{line_number} has been deleted \n"
      File.open('save_file.json', 'w') { |file| file.puts save_states }
    end

    print_main_menu
  end

  def gets_save_file_option(save_states)
    option = gets.chomp
    return delete_line(option, save_states) if option =~ /\Adel \d*\z/
    if valid_save_line?(option, save_states.length)
      return load_line(save_states[option.to_i - 1])
    end

    puts "    Sorry, that is not a valid option.\n"
    print_main_menu
  end

  def load_line(line)
    @word =      JSON.parse(line)['word']
    @alphabet =  JSON.parse(line)['alphabet']
    @remaining = JSON.parse(line)['remaining']
  end

  def print_masked_word(word, alphabet)
    word.gsub(/[#{alphabet}]/i, '_').split('').join(' ')
  end

  def print_save_file(hash, index)
    puts '    ' + (index + 1).to_s + ' - ' +
         print_masked_word(hash['word'], hash['alphabet']).ljust(24) +
         ' Remaining Tries: ' + hash['remaining'].to_s
  end

  def print_save_menu
    if File.zero?('save_file.json') || !File.exist?('save_file.json')
      puts "    There are no saved games. Starting new game. \n\n"
      return
    end

    puts '    Please choose a game to load.'
    puts '    Or to delete a game, type del followed by the number (eg: del 1)'

    show_saved_games
  end

  def show_saved_games
    save_states = File.readlines 'save_file.json'
    save_states.each_with_index do |line, index|
      print_save_file(JSON.parse(line), index)
    end

    gets_save_file_option(save_states)
  end

  def valid_save_line?(option, length)
    if option =~ /\A\d*\z/
      option.to_i.between?(1, length)
    elsif option =~ /\Adel \d*\z/
      option.slice(4..-1).to_i.between?(1, length)
    end
  end
end
