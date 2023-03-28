# frozen_string_literal: true

# Board for the Tic-Tac-Toe Game
class Board
  attr_reader :tiles, :row_one, :row_two, :row_three

  def initialize
    @tiles = %w[1 2 3 4 5 6 7 8 9]
    @divider = '---+---+---'
  end

  def update_board
    @row_one = " #{tiles[0]} | #{tiles[1]} | #{tiles[2]}"
    @row_two = " #{tiles[3]} | #{tiles[4]} | #{tiles[5]}"
    @row_three = " #{tiles[6]} | #{tiles[7]} | #{tiles[8]}"
  end

  def show_board
    puts ''
    puts @row_one
    puts @divider
    puts @row_two
    puts @divider
    puts @row_three
    puts ''
  end
end

# Player
class Player
  attr_reader :name, :tile

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def legal_move?(board, tile)
    @condition_one = false
    @condition_two = false

    if (1..9).include?(tile) == false
      puts 'Please type a valid number between 1 and 9'
      @condition_one = false
    else
      @condition_one = true
    end

    if board.tiles[tile - 1] == 'X' || board.tiles[tile - 1] == 'O'
      puts 'There is a symbol there already, please put another tile number'
      @condition_two = false
    else
      @condition_two = true
    end

    @conditions = true if @condition_one == true && @condition_two == true
  end

  def move(board)
    board.show_board
    puts "#{@name}, please type a number to select your tiles between 1 and 9"

    @conditions = false
    until @conditions
      tile = gets.chomp.to_i
      legal_move?(board, tile)
    end

    board.tiles[tile - 1] = @symbol
    board.update_board
  end
end

# Winning combinations
WIN_COMBS = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
             [0, 3, 6], [1, 4, 7], [2, 5, 8],
             [0, 4, 8], [2, 4, 6]].freeze

# Checks if a player is already win
def game_check(combinations, board)
  if combinations.any? { |comb| board.tiles.values_at(*comb).uniq.length == 1 }
    'win'
  elsif board.tiles.count('X') == 5
    'draw'
  end
end

# Game
def game(player_one, player_two, board)
  game_end = false
  until game_end
    player_one.move(board)
    winner = player_one.name
    game_end = game_check(WIN_COMBS, board)

    break if game_end == 'win' || game_end == 'draw'

    player_two.move(board)
    winner = player_two.name
    game_end = game_check(WIN_COMBS, board)
  end

  puts "Congratulations! #{winner} wins the game!" if game_end == 'win'
  puts 'The game ends with a shocking draw!!!' if game_end == 'draw'
  board.show_board
end

# Introduction
puts 'Welcome to the Tic-Tac-Toe game.'
puts 'This is a game where you need to beat the other player'
puts 'by connecting three symbols on a straight or diagonal line'
puts ''

# Demo
board = Board.new

puts 'What is the name of player 1?'
player_one_name = gets.chomp
player_one = Player.new(player_one_name, 'X')

puts 'What is the name of player 2?'
player_two_name = gets.chomp
player_two = Player.new(player_two_name, 'O')

board.update_board

game(player_one, player_two, board)
