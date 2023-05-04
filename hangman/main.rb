# frozen_string_literal: true

require 'yaml'
# require 'pry-byebug'

# Game
class Game
  attr_accessor :word, :word_array, :hint, :hint_array, :chances, :wrong_characters

  def initialize(dictionary)
    @word = get_word(dictionary)
    @word_array = word.split('')
    @hint_array = (String.new('_') * word.length).split('')
    @hint = hint_array.join(' ')
    @chances = 7
    @wrong_characters = []
    introduction
  end

  def get_word(file)
    words = File.readlines(file)

    # removes '\n' from the string
    words.map! { |word| word.gsub!(/\n/, '') }

    # filter to contain only words with 5-12 characters long.
    words.select! { |word| word.length > 4 && word.length < 13 }
    words.sample
  end

  def game_check
    if chances.zero? || @word == @hint_array.join('')
      if chances.zero?
        puts ''
        puts 'You lost the game.'
        puts "The secret word is '#{@word}'"
      else
        puts ''
        puts hint
        puts ''
        puts 'You win!'
      end
      puts ''
      puts 'Play again?'
      game_end = ''
      until game_end == 'y' || game_end == 'n'
        puts "Type 'y' to play again or 'n' to end the game."
        game_end = gets.chomp
      end
      game_end == 'y' ? Game.new('google-10000-english-no-swears.txt') : exit
    else
      new_game
    end
  end

  def guess_check(word_array, guess)
    new_game until (guess.length == 1 && guess =~ /[a-z]/) || guess == 'save'

    if guess == 'save'
      save_game
    elsif word_array.any?(guess)
      update_hint(guess)
    elsif wrong_characters.any?(guess)
      game_check
    else
      @chances -= 1
      wrong_characters.push(guess)
      game_check
    end
  end

  def update_hint(guess)
    word_array.each_with_index do |char, idx|
      hint_array[idx] = guess if char == guess
    end

    @hint = hint_array.join(' ')

    game_check

    new_game
  end

  def introduction
    puts `clear`
    puts 'Welcome to Hangman.'
    puts 'In this game, you have to guess the secret word by'
    puts 'guessing each letter that are in the secret word.'
    puts 'You have seven chances to guess.'
    puts ''

    select_game
  end

  def select_game
    puts "Type '1' to start a new game, or"
    puts "Type '2' to load a saved game."

    selection = gets.chomp

    until selection == '1' || selection == '2'
      puts 'Please type a valid selection.'
      selection = gets.chomp
    end

    if selection == '1'
      new_game
    else
      load_game
    end
  end

  def new_game
    puts `clear`
    puts "You have #{chances} chances remaining."
    puts 'Guess the secret word!'
    puts ''
    puts hint
    puts ''
    puts "Wrong characters: #{wrong_characters}"
    puts "Type any letter from a to z to guess or type 'save' to save the progress."
    guess = gets.chomp
    guess.downcase!
    guess_check(word_array, guess)
  end

  def save_game
    save_file_name = ''
    save_data = { chances: chances, word: word, hint: hint, wrong_characters: wrong_characters }
    until save_file_name =~ /[a-z0-9]/
      puts `clear`
      puts 'Please type a name for the save file. (Can only use a-z and 0-9)'
      save_file_name = gets.chomp
    end
    Dir.mkdir('save') unless Dir.exist?('save')
    save_file = File.open("./save/#{save_file_name}.yaml", 'w')
    serialized_save_file = YAML.dump(save_data)
    save_file.write(serialized_save_file)
    save_file.close
    puts "Progress saved as #{save_file_name}.yaml"
    end_game?
  end

  def load_game
    files = Dir.entries('./save')
    file_name = ''
    until files.any?(file_name)
      puts `clear`
      puts 'Select which save files you want to load (Type the file name. e.g. "abc.yaml")'
      puts files[2..]
      file_name = gets.chomp
    end
    file = File.open("./save/#{file_name}", 'r')
    serialized_data = file.readlines
    data = YAML.load(serialized_data.join(''))
    @chances = data[:chances]
    @word = data[:word]
    @word_array = @word.split('')
    @hint = data[:hint]
    @hint_array = @hint.split(' ')
    @wrong_characters = data[:wrong_characters]
    new_game
  end

  def end_game?
    choice = ''
    until choice.length == 1 && (choice == 'c' || choice == 'q')
      puts "Type 'q' to quit the game or 'c' to continue."
      choice = gets.chomp
    end
    if choice == 'q'
      puts `clear`
      puts 'Thanks for playing!'
      exit
    else
      new_game
    end
  end
end

Game.new('google-10000-english-no-swears.txt')