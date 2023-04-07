# frozen_string_literal: true

# Game
class Game
  attr_accessor :word, :word_array, :hint, :hint_array, :chances

  def initialize(dictionary)
    @word = get_word(dictionary)
    @word_array = word.split('')
    @hint_array = (String.new('_') * word.length).split('')
    @hint = hint_array.join(' ')
    @chances = 7
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

  def new_game
    puts "You have #{chances} chances remaining."
    puts 'Guess the word!'
    puts ''
    puts hint
    puts ''
    guess = gets.chomp
    guess_check(word_array, guess)
  end

  def guess_check(word_array, guess)
    if word_array.any?(guess)
      update_hint(guess)
    else
      @chances -= 1
      new_game
    end
  end

  def update_hint(guess)
    word_array.each_with_index do |char, idx|
      hint_array[idx] = guess if char == guess
    end
    @hint = hint_array.join(' ')
    new_game
  end

  def introduction
    puts 'Welcome to Hangman.'
    puts 'In this game, you have to guess the secret word by'
    puts 'guessing each letter that are in the secret word.'
    puts "You have seven chances to guess. If you don't get it right,"
    puts 'the man will be hanged. :('
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
      puts 'ayaya'
    end
  end
end

Game.new('google-10000-english-no-swears.txt')
