require 'connect_four.rb'


describe ConnectFourGame do
  describe "#attributes" do
    context "when the game is initialized" do
      it "creates a new array (the grid) with 42 spaces" do
        expect(subject.grid.length).to eql(42)
      end
      it "starts off with a white circle as its current mark" do
        expect(subject.current_mark).
        to eql("\u26AB".encode('utf-8'))
      end
    end
  end

  describe "#display" do
    context "when the grid has no marks" do
      it "does not display any markings" do
        expect(subject.display).
        to_not match(/\p{InMiscellaneous_Symbols}+/)
      end
    end

    context "when the grid has one marking in square 2" do
      it "displays the marking" do
        subject.grid[1] = 'f'
        expect(subject.display).to match(/f/)
      end
    end

    context "when the display is output to the command line" do
      it "displays seven column numbers, starting at 0" do
        expect(subject.display).to match(/((\d\s+)+){7}/)
      end
    end
  end

  describe "#next_turn" do
    before do
      $stdout = StringIO.new("")
      allow(subject).to receive(:get_input).and_return('6')
    end
    context "when first called" do
      it "outputs a line asking for user_input" do
        expect{subject.next_turn}.
        to output(/Enter a column number to make your move./).to_stdout
      end

      it "outputs the display/grid" do
        expect{subject.next_turn}.to output(/#{subject.display}/).to_stdout
      end
    end

    context "when inputting 6" do
      it "marks the bottom square in the 7th column" do
        subject.next_turn
        expect(subject.grid[41]).
        to eql("\u26AB".encode('utf-8'))
      end
    end

    context "when the input is not valid" do
      it "outputs an error message" do
        #Impossible to test because an infinite loop would occur. (while + gets)
        #Must be tested by hand.
      end
    end

    context "when 6 is input and the appropriate square is marked" do
      it "switches the current mark to the other color" do
        subject.next_turn
        expect(subject.current_mark).
        to eql("\u26AA".encode('utf-8'))
      end
    end

    context "when the board is full and the last mark is made" do
      it "calls tie game" do
        (0..42).each { |num| subject.grid[num] = "t" }
        subject.grid[6] = " "
        allow(subject).to receive(:tie_game)
        expect(subject).to receive(:tie_game)
        subject.next_turn
      end
    end

    context "when a move is made that makes four in a row" do
      it "calls game_over" do
        (38..40).each { |num| subject.grid[num] = subject.current_mark}
        expect(subject).to receive(:game_over)
        subject.next_turn
      end
    end
  end

  describe "#victory_move?" do
    context "when three in a row are made horizontally" do
      it "returns true on the final (fourth) move" do
        (0..2).each { |num| subject.grid[num] = subject.current_mark }
        expect(subject.victory_move?(3)).to be true
      end
    end

    context "when three in a column are made vertically" do
      it "returns true on the final move" do
        [0,7,14].each { |num| subject.grid[num] = subject.current_mark }
        expect(subject.victory_move?(21)).to be true
      end
    end

    context "when a top left to bottom right diagonal of three is made" do
      it "returns true on the final move" do
        [0,8,16].each { |num| subject.grid[num] = subject.current_mark }
        expect(subject.victory_move?(24)).to be true
      end
    end

    context "when a bottom left to top right diagonal of three is made" do
      it "returns true on the final move" do
        [6,12,18].each { |num| subject.grid[num] = subject.current_mark }
        expect(subject.victory_move?(24)).to be true
      end
    end

    context "when three in a row are made of a different mark" do
      it "returns false on the final move" do
        [6,12,18].each { |num| subject.grid[num] = 'm'}
        expect(subject.victory_move?(24)).to be false
      end
    end
  end

  describe "#full_grid?" do
    context "when the whole grid is filled" do
      it "returns true" do
        subject.grid.map! { |square| square = "m" }
        expect(subject.full_grid?).to be true
      end
    end

    context "when the grid is not full" do
      it "returns false" do
        expect(subject.full_grid?).to be false
      end
    end
  end


end
