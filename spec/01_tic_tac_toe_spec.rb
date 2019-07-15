require_relative '../lib/tic_tac_toe.rb'

describe './lib/tic_tac_toe.rb' do
  describe 'WIN_COMBINATIONS' do
    it 'defines a constant WIN_COMBINATIONS with arrays for each win combination' do
      expect(WIN_COMBINATIONS.size).to eq(8)

      expect(WIN_COMBINATIONS).to include_array([0, 1, 2])
      expect(WIN_COMBINATIONS).to include_array([3, 4, 5])
      expect(WIN_COMBINATIONS).to include_array([6, 7, 8])
      expect(WIN_COMBINATIONS).to include_array([0, 3, 6])
      expect(WIN_COMBINATIONS).to include_array([1, 4, 7])
      expect(WIN_COMBINATIONS).to include_array([2, 5, 8])
      expect(WIN_COMBINATIONS).to include_array([0, 4, 8])
      expect(WIN_COMBINATIONS).to include_array([6, 4, 2])
    end
  end

  describe '#display_board' do
    it 'prints arbitrary arrangements of the board' do
      board = %w[X X X X O O X O O]

      output = capture_puts { display_board(board) }

      expect(output).to include(' X | X | X ')
      expect(output).to include('-----------')
      expect(output).to include(' X | O | O ')
      expect(output).to include('-----------')
      expect(output).to include(' X | O | O ')

      board = %w[X O X O X X O X O]

      output = capture_puts { display_board(board) }

      expect(output).to include(' X | O | X ')
      expect(output).to include('-----------')
      expect(output).to include(' O | X | X ')
      expect(output).to include('-----------')
      expect(output).to include(' O | X | O ')
    end
  end

  describe '#input_to_index' do
    it 'converts user_input to an integer' do
      user_input = '1'

      expect(input_to_index(user_input)).to be_a(Integer)
    end

    it 'subtracts 1 from the user_input' do
      user_input = '6'

      expect(input_to_index(user_input)).to be(5)
    end

    it 'returns -1 for strings without integers' do
      user_input = 'invalid'

      expect(input_to_index(user_input)).to be(-1)
    end
  end

  describe '#move' do
    it 'does not allow for a default third argument' do
      board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']

      expect { move(board, 0) }.to raise_error(ArgumentError)
    end

    it 'takes three arguments: board, position, and player token' do
      board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']

      expect { move(board, 0, 'X') }.to_not raise_error
    end

    it 'allows "X" player in the bottom right and "O" in the top left ' do
      board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
      move(board, 0, 'O')
      move(board, 8, 'X')
      expect(board).to eq(['O', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X'])
    end
  end

  describe '#position_taken?' do
    it 'returns true/false based on position in board' do
      board = ['X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'O']

      position = 0
      expect(position_taken?(board, position)).to be(true)

      position = 8
      expect(position_taken?(board, position)).to be(true)

      position = 1
      expect(position_taken?(board, position)).to be(false)

      position = 7
      expect(position_taken?(board, position)).to be(false)
    end
  end

  describe '#valid_move?' do
    it 'returns true/false based on position' do
      board = [' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ']

      position = 0
      expect(valid_move?(board, position)).to be_truthy

      position = 4
      expect(valid_move?(board, position)).to be_falsey

      position = -1
      expect(valid_move?(board, position)).to be_falsey
    end
  end

  describe '#turn' do
    it 'makes valid moves' do
      board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']

      allow($stdout).to receive(:puts)

      expect(self).to receive(:gets).and_return('1')

      turn(board)

      expect(board).to match_array(['X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])
    end

    it 'asks for input again after a failed validation' do
      board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']

      allow($stdout).to receive(:puts)

      expect(self).to receive(:gets).and_return('invalid')
      expect(self).to receive(:gets).and_return('1')

      turn(board)
    end
  end

  describe '#turn_count' do
    it 'counts occupied positions' do
      board = ['O', ' ', ' ', ' ', 'X', ' ', ' ', ' ', 'X']

      expect(turn_count(board)).to eq(3)
    end
  end

  describe '#current_player' do
    it 'returns the correct player, X, for the third move' do
      board = ['O', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ']

      expect(current_player(board)).to eq('X')
    end
  end

  describe '#won?' do
    it 'returns false for a draw' do
      board = %w[X O X O X X O X O]

      expect(won?(board)).to be_falsey
    end

    it 'returns true for a win' do
      board = %w[X O X O X X O O X]

      expect(won?(board)).to be_truthy
    end
  end

  describe '#full?' do
    it 'returns true for a draw' do
      board = %w[X O X O X X O X O]

      expect(full?(board)).to be_truthy
    end

    it 'returns false for an in-progress game' do
      board = ['X', ' ', 'X', ' ', 'X', ' ', 'O', 'O', ' ']

      expect(full?(board)).to be_falsey
    end
  end

  describe '#draw?' do
    it 'calls won?' do
      board = %w[X O X O X X O X O]

      expect(self).to receive(:won?).with(board)
      draw?(board)
    end

    it 'calls full?' do
      board = %w[X O X O X X O X O]

      expect(self).to receive(:full?).with(board)
      draw?(board)
    end

    it 'returns true for a draw' do
      board = %w[X O X O X X O X O]

      expect(draw?(board)).to be_truthy
    end

    it 'returns false for a won game' do
      board = %w[X O X O X X O O X]

      expect(draw?(board)).to be_falsey
    end

    it 'returns false for an in-progress game' do
      board = ['X', ' ', 'X', ' ', 'X', ' ', 'O', 'O', 'X']

      expect(draw?(board)).to be_falsey
    end
  end

  describe '#over?' do
    it 'returns true for a draw' do
      board = %w[X O X O X X O X O]

      expect(over?(board)).to be_truthy
    end

    it 'returns true for a won game' do
      board = %w[X O X O X X O O X]

      expect(over?(board)).to be_truthy
    end

    it 'returns false for an in-progress game' do
      board = ['X', ' ', 'X', ' ', 'X', ' ', 'O', 'O', ' ']

      expect(over?(board)).to be_falsey
    end
  end

  describe '#winner' do
    it 'return X when X won' do
      board = ['X', ' ', ' ', ' ', 'X', ' ', ' ', ' ', 'X']

      expect(winner(board)).to eq('X')
    end

    it 'returns O when O won' do
      board = ['X', 'O', ' ', ' ', 'O', ' ', ' ', 'O', 'X']

      expect(winner(board)).to eq('O')
    end

    it 'returns nil when no winner' do
      board = ['X', 'O', ' ', ' ', ' ', ' ', ' ', 'O', 'X']

      expect(winner(board)).to be_nil
    end
  end
end

WIN_COMBINATIONS = [
  [0,1,2], # Top
  [3,4,5], # Middle horizontal
  [6,7,8], # Bottom
  [0,3,6], # Left
  [1,4,7], # Middle vertical
  [2,5,8], # Right
  [0,4,8], # Right Diagonal
  [2,4,6]  # Left Diagonal
]

def display_board(board)
  puts " #{board[0]} | #{board[1]} | #{board[2]} "
  puts "-----------"
  puts " #{board[3]} | #{board[4]} | #{board[5]} "
  puts "-----------"
  puts " #{board[6]} | #{board[7]} | #{board[8]} "
end

def input_to_index(user_input)
  user_input.to_i-1
end

def move(board, index, token = "X")
  board[index] = token
end

def position_taken?(board, index)
  (board[index] == " " || board[index] == "" || board[index] == nil)?
    false : true
end

def valid_move?(board, index)
  index.between?(0, 8) && !position_taken?(board, index)
end

def turn(board)
  puts "Please enter 1-9:"
  user_input = gets.strip
  index = input_to_index(user_input)
  if valid_move?(board, index)
    move(board, index)
    display_board(board)
  else
    turn(board)
  end
end

def turn_count(board)
  counter= 0

   board.each do|a| if a == "X"||a == "O"
  counter+=1
    end

  end
  return counter
end

def current_player(board)
  if turn_count(board) % 2 == 0
    return "X"
else
  return "O"
end
end

def won?(board)
  if board.all? { |place| place == ' ' }
    return false
  end
  for combo in WIN_COMBINATIONS
    if combo.all? { |index| board[index] == 'X' }
      return combo
    elsif combo.all? { |index| board[index] == 'O' }
      return combo
    end
  end
  false
end

def full?(board)
  board.all? { |place| place != ' ' }
end

def draw?(board)
  full?(board) && !won?(board)
end

def over?(board)
  if won?(board)
    return true
  end

  draw?(board) || full?(board)
end

def winner(board)
  if won?(board)
    board[won?(board)[0]]
  end
end
