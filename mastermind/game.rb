# frozen_string_literal: true

# Display
module Display
  # Unicode Box Drawing
  HOR = "\u2550"
  VER = "\u2551"
  TOP_LEFT = "\u2554"
  TOP_RIGHT = "\u2557"
  BOT_LEFT = "\u255A"
  BOT_RIGHT = "\u255D"
  T_TOP = "\u2566"
  T_BOT = "\u2569"
  T_LEFT = "\u2560"
  T_RIGHT = "\u2563"
  T_CROSS = "\u256C"

  def top_row
    puts TOP_LEFT + HOR * 13 + T_TOP + HOR * 9 + TOP_RIGHT
  end

  def mid_row(selected=[0,0,0,0], hint=[0,0,0,0])
    # Gets the color from Game class and selection from user input
    @colors_peg = " #{@colors[selected[0]]} #{@colors[selected[1]]} #{@colors[selected[2]]} #{@colors[selected[3]]} "
    @clues_peg = " #{@clues[hint[0]]} #{@clues[hint[1]]} #{@clues[hint[2]]} #{@clues[hint[3]]} "
    puts VER + @colors_peg + VER + @clues_peg + VER
    puts T_LEFT + HOR * 13 + T_CROSS + HOR * 9 + T_RIGHT
  end

  def bot_row
    puts BOT_LEFT + HOR * 13 + T_BOT + HOR * 9 + BOT_RIGHT
  end

  def update_display
    top_row
    mid_row(rows[1][0], rows[1][1])
    mid_row(rows[2][0], rows[2][1])
    mid_row(rows[3][0], rows[3][1])
    mid_row(rows[4][0], rows[4][1])
    mid_row(rows[5][0], rows[5][1])
    mid_row(rows[6][0], rows[6][1])
    mid_row(rows[7][0], rows[7][1])
    mid_row(rows[8][0], rows[8][1])
    mid_row(rows[9][0], rows[9][1])
    mid_row(rows[10][0], rows[10][1])
    bot_row
  end
end

# Code Maker
module CodeMaker
  attr_accessor :secret_code

  def set_code
    puts 'Please type four combination of numbers from 1 to 6 to set '
    puts 'your secret code. e.g. "1123" (🔴, 🔴, 🔵, 🟠)'

    @secret_code = gets.chomp
    until @secret_code.length == 4
      puts 'Please put a valid combination of four numbers from 1 to 6'
      @secret_code = gets.chomp
    end
    @secret_code = @secret_code.split('').map { |num| num.to_i }
  end
end

# Code Breaker
module CodeBreaker
  @counter = 1

  def break_code
    puts 'Guess the secret code by typing four combination of numbers'
    puts 'from 1 to 6. e.g. "2243" (🔵, 🔵, 🟢, 🟠)'

    @guess = gets.chomp
    until @guess.length == 4
      puts 'Please put a valid combination of four numbers from 1 to 6'
      @guess = gets.chomp
    end

    update_display

    if check_code(@guess)
      puts "Congratulations! You have breaked the code!! (#{secret_code})"
    else
      @counter += 1
      puts "#{@counter}. The code is wrong, try again."
      break_code
    end
  end

  def check_code(guess)
    @guess == guess
  end
end

# Game
class Game
  attr_accessor :clues, :rows

  include Display
  include CodeMaker
  include CodeBreaker

  def initialize
    @colors = { 1 => '🔴', 2 => '🔵',
                3 => '🟠', 4 => '🟢',
                5 => '🟣', 6 => '🟤', 0 => '  ' }.freeze

    @clues = { 1 => '○', 2 => '●', 0 => ' ' }
    @rows = { 1 => [[1, 2, 3, 4], [1, 1, 2, 2]],
              2 => [[0, 0, 0, 0], [0, 0, 0, 0]],
              3 => [[0, 0, 0, 0], [0, 0, 0, 0]],
              4 => [[0, 0, 0, 0], [0, 0, 0, 0]],
              5 => [[0, 0, 0, 0], [0, 0, 0, 0]],
              6 => [[0, 0, 0, 0], [0, 0, 0, 0]],
              7 => [[0, 0, 0, 0], [0, 0, 0, 0]],
              8 => [[0, 0, 0, 0], [0, 0, 0, 0]],
              9 => [[0, 0, 0, 0], [0, 0, 0, 0]],
              10 => [[0, 0, 0, 0], [0, 0, 0, 0]] }
    introduction
  end

  def introduction
    puts 'Welcome to the game of Mastermind.'
    puts 'In this game, there are Code Breaker and Code Maker'
    puts "Code Breaker's job is to guess the secret code made by the Code Maker."
    puts 'The code must be in the correct color and order.'
    puts "Meanwhile, the Code Maker's job is to make a secret code"
    puts 'that the Code Breaker will try to break'
    puts "There will be clues about the secret's code correct color and order"
    puts 'each time the Code Breaker guess.'
    puts ''
    puts 'The Clues are:'
    puts '○ will show up if a color is correct but in a wrong position.'
    puts '● will show up if a color is correct and in a correct position.'
    puts ''
    puts 'Type 1 if you want to be the Code Maker'
    puts 'Type 2 if you want to be the Code Breaker'
    @input = gets.chomp
    until @input.length == 1 && (@input == '1' || @input == '2')
      puts 'Please type a valid number'
      @input = gets.chomp
    end
  end
end

# Demo

Game.new