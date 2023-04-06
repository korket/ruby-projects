# frozen_string_literal: true

# Game
class Game
  def initialize(dictionary)
    @word = get_word(dictionary)
    @selection = ''
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

  def introduction
    puts 'Welcome to Hangman.'
    puts 'In this game, you have to guess the secret word by'
    puts 'guessing each letter that are in the secret word.'
    puts "You have seven chances to guess, if you don't get it right,"
    puts 'the man will be hanged. :('
    puts ''
    select_game
  end

  def select_game
    puts "Type '1' to start a new game, or"
    puts "Type '2' to load a saved game."
    @selection = gets.chomp
    until @selection == '1' || @selection == '2'
      puts 'Please type a valid selection.'
      @selection = gets.chomp
    end
  end
end

Game.new('google-10000-english-no-swears.txt')
