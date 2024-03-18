# frozen_string_literal: true

require "./lib/piece/pawn"

describe Pawn do
  subject(:white_pawn) { described_class.new("white") }
  subject(:black_pawn) { described_class.new("black") }

  describe "#adjacent_squares" do
    context "when the pawn has moved" do
      before do
        allow(white_pawn).to receive(:unmoved).and_return(false)
        allow(black_pawn).to receive(:unmoved).and_return(false)
      end

      it "white can only move 1 square, and it adds it to its path" do
        square = [2, 4]
        result = white_pawn.adjacent_squares(square)
        expect(result).to eql({ [3, 4] => [[3, 4]] })
      end

      it "black can only move 1 square, and it adds it to its path" do
        square = [5, 2]
        result = black_pawn.adjacent_squares(square)
        expect(result).to eql({ [4, 2] => [[4, 2]] })
      end
    end

    context "when the pawn hasn't moved" do
      before do
        allow(white_pawn).to receive(:unmoved).and_return(true)
        allow(black_pawn).to receive(:unmoved).and_return(true)
      end

      it "white can move 1 or 2 squares, and it adds them to its path" do
        square = [1, 3]
        result = white_pawn.adjacent_squares(square)
        expect(result).to eql({ [2, 3] => [[2, 3]], [3, 3] => [[2, 3], [3, 3]] })
      end

      it "black can move 1 or 2 squares, and it adds them to its path" do
        square = [6, 5]
        result = black_pawn.adjacent_squares(square)
        expect(result).to eql({ [5, 5] => [[5, 5]], [4, 5] => [[5, 5], [4, 5]] })
      end
    end
  end
end
