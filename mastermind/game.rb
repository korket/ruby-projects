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
    (1..10).each do |i|
      mid_row(rows[i][0], rows[i][1])
    end
    bot_row
  end
end

# Code Maker
module CodeMaker
  attr_accessor :secret_code

  def set_code
    puts 'Please type four combination of numbers between 1 and 6 to set '
    puts 'your secret code. e.g. "1123" (🔴, 🔴, 🔵, 🟠)'

    @secret_code = gets.chomp
    until @secret_code.length == 4
      puts 'Please put a valid combination of four numbers between 1 and 6'
      @secret_code = gets.chomp
    end
  end

  def computer_guess
    @guess = Array.new(4, 1).map! { |x| x = rand(1..6) }.join
    rows[counter][0] = @guess.split('').map { |num| num.to_i}
    get_hint
    update_display
    check_computer_guess
  end

  def check_computer_guess
    if @secret_code == @guess
      game_lose
    elsif @counter == 10
      game_win
    else
      @counter += 1
      computer_guess
    end
  end
end

# Code Breaker
module CodeBreaker
  def guess_code
    @guess = gets.chomp
    until @guess.length == 4
      puts 'Please put a valid combination of four numbers between 1 and 6'
      @guess = gets.chomp
    end

    rows[counter][0] = @guess.split('').map { |num| num.to_i}
    get_hint
    update_display
    check_code
  end

  def get_hint
    @same_both = 0
    @same_color = 0

    @splitted_code = @secret_code.split('')
    @splitted_guess = @guess.split('')

    @splitted_code.each_with_index do |code, idx|
      if @splitted_guess[idx] == code
        @same_both += 1
        @splitted_code[idx] = nil
        @splitted_guess[idx] = nil
      end
    end

    @splitted_guess.compact.each do |code|
      if @splitted_code.include?(code)
        @same_color += 1
        @splitted_code[@splitted_code.index(code)] = nil
      end
    end
    rows[counter][1] = Array.new(@same_both, 2) + Array.new(@same_color, 1)

    (4 - rows[counter][1].length).times do
      rows[counter][1].push(0)
    end
  end

  def check_code
    if secret_code == @guess
      game_win
    elsif @counter == 10
      game_lose
    else
      @counter += 1
      puts "#{@counter}. The code is wrong, try again."
      guess_code
    end
  end
end

# Game
class Game
  attr_accessor :clues, :rows, :counter

  include Display
  include CodeMaker
  include CodeBreaker

  def initialize
    @colors = { 1 => '🔴', 2 => '🔵',
                3 => '🟠', 4 => '🟢',
                5 => '🟣', 6 => '🟤', 0 => '  ' }.freeze

    @clues = { 1 => '○', 2 => '●', 0 => ' ' }
    @rows = {}
    (1..10).each do |i|
      @rows[i] = [[0, 0, 0, 0], [0, 0, 0, 0]]
    end
    @secret_code = ''
    @input = ''
    @counter = 1
    introduction
  end

  def game_win
    if @input == '2'
      puts 'Congratulations, you breaked the code!'
    else
      puts "Congratulations, you win because the computer can't crack the code!"
    end
  end

  def game_lose
    if @input == '2'
      puts "Sadly, you've lost the game because you can't crack the code in 10 tries."
      puts "The code is '#{@secret_code}'"
    else
      puts 'The computer cracked the code, you lost!'
    end
  end

  def introduction
    puts 'Welcome to the game of Mastermind.'
    puts 'In this game, there are Code Breaker and Code Maker'
    puts ''
    puts "Code Breaker's job is to guess the secret code made by the Code Maker."
    puts 'The code must be in the correct color and order.'
    puts ''
    puts "Meanwhile, the Code Maker's job is to make a secret code"
    puts 'that the Code Breaker will try to break'
    puts ''
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

    if @input == '1'
      set_code
      computer_guess
    else
      puts 'Guess the secret code by typing four combination of numbers'
      puts 'between 1 and 6. e.g. "2243" (🔵, 🔵, 🟢, 🟠)'

      @secret_code = Array.new(4, 1).map! { |x| x = rand(1..6) }.join
      guess_code
    end

    update_display
  end
end

# Demo
Game.new
