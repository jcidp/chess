# frozen_string_literal: true

require "./lib/piece/pawn"

describe Pawn do
  subject(:white_pawn) { described_class.new("white") }
  subject(:black_pawn) { described_class.new("black") }

  describe "#valid_move?" do
    context "when white pawns moves" do
      it "returns true from 1,2 to 2,2" do
        from = [1, 2]
        to = [2, 2]
        result = white_pawn.valid_move?(from, to)
        expect(result).to be true
      end

      it "returns false from 6,2 to 5,2" do
        from = [6, 2]
        to = [5, 2]
        result = white_pawn.valid_move?(from, to)
        expect(result).to be false
      end

      it "returns false from 3,3 to 4,4" do
        from = [3, 3]
        to = [4, 4]
        result = white_pawn.valid_move?(from, to)
        expect(result).to be false
      end
    end

    context "when white pawn moves 2 squares on its first move" do
      before do
        allow(white_pawn).to receive(:unmoved).and_return(true)
      end

      it "returns false from 6,2 to 4,2" do
        from = [6, 2]
        to = [4, 2]
        result = white_pawn.valid_move?(from, to)
        expect(result).to be false
      end

      it "returns true from 1,3 to 3,3" do
        from = [1, 3]
        to = [3, 3]
        result = white_pawn.valid_move?(from, to)
        expect(result).to be true
      end
    end

    context "when white pawn moves 2 squares on a subsequent move" do
      before do
        allow(white_pawn).to receive(:unmoved).and_return(false)
      end

      it "returns false from 1,3 to 3,3" do
        from = [1, 3]
        to = [3, 3]
        result = white_pawn.valid_move?(from, to)
        expect(result).to be false
      end
    end

    context "when black pawns moves" do
      it "returns true from 6,2 to 5,2" do
        from = [6, 2]
        to = [5, 2]
        result = black_pawn.valid_move?(from, to)
        expect(result).to be true
      end

      it "returns false from 1,2 to 2,2" do
        from = [1, 2]
        to = [2, 2]
        result = black_pawn.valid_move?(from, to)
        expect(result).to be false
      end

      it "returns false from 4,4 to 3,3" do
        from = [4, 4]
        to = [3, 3]
        result = black_pawn.valid_move?(from, to)
        expect(result).to be false
      end
    end
  end

  context "when black pawn moves 2 squares on its first move" do
    before do
      allow(black_pawn).to receive(:unmoved).and_return(true)
    end
    it "returns false from 1,3 to 3,3" do
      from = [1, 3]
      to = [3, 3]
      result = black_pawn.valid_move?(from, to)
      expect(result).to be false
    end

    it "returns true from 6,2 to 4,2" do
      from = [6, 2]
      to = [4, 2]
      result = black_pawn.valid_move?(from, to)
      expect(result).to be true
    end
  end

  context "when black pawn moves 2 squares on a subsequent move" do
    before do
      allow(black_pawn).to receive(:unmoved).and_return(false)
    end

    it "returns false from 6,2 to 4,2" do
      from = [6, 2]
      to = [4, 2]
      result = black_pawn.valid_move?(from, to)
      expect(result).to be false
    end
  end

  describe "#valid_take?" do
    context "when white pawns takes" do
      it "returns false from 1,2 to 2,2" do
        from = [1, 2]
        to = [2, 2]
        result = white_pawn.valid_take?(from, to)
        expect(result).to be false
      end

      it "returns false from 1,3 to 3,3" do
        from = [1, 3]
        to = [3, 3]
        result = white_pawn.valid_take?(from, to)
        expect(result).to be false
      end

      it "returns false from 6,2 to 5,2" do
        from = [6, 2]
        to = [5, 2]
        result = white_pawn.valid_take?(from, to)
        expect(result).to be false
      end

      it "returns true from 3,3 to 4,4" do
        from = [3, 3]
        to = [4, 4]
        result = white_pawn.valid_take?(from, to)
        expect(result).to be true
      end
    end

    context "when black pawns takes" do
      it "returns false from 6,2 to 5,2" do
        from = [6, 2]
        to = [5, 2]
        result = black_pawn.valid_take?(from, to)
        expect(result).to be false
      end

      it "returns false from 6,2 to 4,2" do
        from = [6, 2]
        to = [4, 2]
        result = black_pawn.valid_take?(from, to)
        expect(result).to be false
      end

      it "returns false from 1,2 to 2,2" do
        from = [1, 2]
        to = [2, 2]
        result = black_pawn.valid_take?(from, to)
        expect(result).to be false
      end

      it "returns true from 4,4 to 3,3" do
        from = [4, 4]
        to = [3, 3]
        result = black_pawn.valid_take?(from, to)
        expect(result).to be true
      end
    end
  end

  describe "#path" do
    context "when moving 2 rows in a move" do
      it "returns a valid path" do
        from = [6, 2]
        to = [4, 2]
        path = black_pawn.path(from, to)
        expect(path).to eql([[5, 2]])
      end
    end

    context "when moving 1 row in a move" do
      it "returns a valid path" do
        from = [6, 2]
        to = [5, 2]
        path = black_pawn.path(from, to)
        expect(path).to eql([])
      end
    end

    context "when taking diagonally" do
      it "returns a valid path" do
        from = [6, 2]
        to = [5, 3]
        path = black_pawn.path(from, to)
        expect(path).to eql([])
      end
    end
  end
end
