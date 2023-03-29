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

  def mid_row(one=0, two=0, three=0, four=0, cone=0, ctwo=0, cthree=0, cfour=0)
    puts VER + " #{@colors[one]} #{@colors[two]} #{@colors[three]} #{@colors[four]} " + VER + " #{@clues[cone]} #{@clues[ctwo]} #{@clues[cthree]} #{@clues[cfour]} " + VER
    puts T_LEFT + HOR * 13 + T_CROSS + HOR * 9 + T_RIGHT
  end

  def bot_row
    puts BOT_LEFT + HOR * 13 + T_BOT + HOR * 9 + BOT_RIGHT
  end
end

# Game
class Game
  attr_accessor :color_one, :color_two, :color_three, :color_four, :clues

  include Display

  def initialize
    @colors = { 1 => '🔴', 2 => '🔵',
                3 => '🟠', 4 => '🟢',
                5 => '🟣', 6 => '🟤', 0 => '  ' }.freeze

    @clues = { 1 => '○', 2 => '●', 0 => ' ' }
  end
end

new_game = Game.new
new_game.top_row
new_game.mid_row(1, 2, 3, 4, 1, 1, 2, 1)
new_game.mid_row
new_game.mid_row
new_game.mid_row
new_game.mid_row
new_game.mid_row
new_game.mid_row
new_game.mid_row
new_game.mid_row
new_game.bot_row
