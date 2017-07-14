class ConnectFourGame
  attr_accessor :grid, :current_mark
  def initialize
    @grid = []
    42.times {@grid << " "}
    @current_mark = "\u26AB"
    @playing = true
  end

  def display
    line = " ---------------------------\n"
    "  0   1   2   3   4   5   6 \n" + line +
    "| #{@grid[0..6].join(' | ')} |\n" + line +
    "| #{@grid[7..13].join(" | ")} |\n" + line +
    "| #{@grid[14..20].join(" | ")} |\n" + line +
    "| #{@grid[21..27].join(" | ")} |\n" + line +
    "| #{@grid[28..34].join(" | ")} |\n" + line +
    "| #{@grid[35..41].join(" | ")} |\n" + line
  end

  def next_turn
    puts display
    puts "Enter a column number to make your move."
    puts "Current marker: #{@current_mark}"
    while input = get_input
      if valid_input?(input) && @grid[input.to_i] == ' '
        marked_square = mark_top_of_column(input)
        break
      else
        puts "That's not a valid column!"
      end
    end
    tie_game if full_grid?
    game_over if victory_move?(marked_square)
    switch_mark
  end

  def mark_top_of_column(column)
    s_index = column.to_i + 35
    until s_index < 0
      if @grid[s_index] == " "
        @grid[s_index] = @current_mark
        break
      else
        s_index -= 7
      end
    end
    s_index
  end

  def victory_move?(move)
    left_right_squares = [0,6,7,13,14,20,21,27,28,34,35,41]
    top_bottom_squares = [0,1,2,3,4,5,6,35,36,37,38,39,40,41]
    all_edges = left_right_squares + top_bottom_squares
    return true if increment_count(move, 1, left_right_squares) >= 3
    return true if increment_count(move, 7, top_bottom_squares) >= 3
    return true if increment_count(move, 6, all_edges) >= 3
    return true if increment_count(move, 8, all_edges) >= 3
    false
  end

  def full_grid?
    @grid.none? {|square| square == " "}
  end

  def play
    while @playing
      next_turn
    end
    next_game?
  end

  private

  def next_game?
    puts "Do you want to start a new game? [YES] or [NO]?"
    while input = get_input.downcase
      case input
      when 'yes'
        new_game = ConnectFourGame.new
        new_game.play
        break
      when 'no'
        puts "Well okay then. I hope you had a lot of fun! Bye!"
        break
      else
        puts "I'm sorry, I didn't understand you. [YES] or [NO]?"
      end
    end
  end

  def game_over
    @playing = false
    puts "#{@current_mark} won this game!"
  end

  def tie_game
    @playing = false
    puts "Tie game! The board is full and no one can win."
  end

  def increment_count(original_square, increment, end_squares)
    first_direction = true; counter = 0; s = original_square
    loop do
      if first_direction
        s += increment
      else
        s -= increment
      end
      counter += 1 if @grid[s] == @current_mark
      if @grid[s] != @current_mark || end_squares.include?(s)
        break unless first_direction
        first_direction = false
        s = original_square
      end
    end
    counter
  end

  def switch_mark
    if @current_mark == "\u26AA"
      @current_mark = "\u26AB"
    else
      @current_mark = "\u26AA"
    end
  end

  def valid_input?(input)
    return true if input[0].match(/[0-6]/)
    false
  end

  def get_input
    input = gets.chomp
    abort("Quitting") if input.downcase == 'end' || input.downcase == "quit"
    input
  end

end

game = ConnectFourGame.new
game.play
