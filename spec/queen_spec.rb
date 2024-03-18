# frozen_string_literal: true

require "./lib/piece/queen"

describe Queen do
  subject(:test_queen) { described_class.new("white") }

  describe "#valid_move?" do
    it "returns true from 2,2 to 2,0" do
      from = [2, 2]
      to = [2, 0]
      result = test_queen.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns true from 7,5 to 1,5" do
      from = [7, 5]
      to = [1, 5]
      result = test_queen.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns true from 0,2 to 5,7" do
      from = [0, 2]
      to = [5, 7]
      result = test_queen.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns true from 7,5 to 6,4" do
      from = [7, 5]
      to = [6, 4]
      result = test_queen.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns false from 7,6 to 6,4" do
      from = [7, 6]
      to = [6, 4]
      result = test_queen.valid_move?(from, to)
      expect(result).to be false
    end
  end

  describe "#path" do
    context "when moving from 3,0 to 3,7" do
      it "returns the correct horizontal path" do
        from = [3, 0]
        to = [3, 7]
        result = test_queen.path(from, to)
        expect(result).to eql([[3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6]])
      end
    end

    context "when moving from 7,5 to 0,5" do
      it "returns the correct vertical path" do
        from = [7, 5]
        to = [0, 5]
        result = test_queen.path(from, to)
        expect(result).to eql([[6, 5], [5, 5], [4, 5], [3, 5], [2, 5], [1, 5]])
      end
    end

    context "when moving from 4,6 to 4,5" do
      it "returns an empty path" do
        from = [4, 6]
        to = [4, 5]
        result = test_queen.path(from, to)
        expect(result).to eql([])
      end
    end

    context "when moving from 0,2 to 5,7" do
      it "returns the correct diagonal path" do
        from = [0, 2]
        to = [5, 7]
        result = test_queen.path(from, to)
        expect(result).to eql([[1, 3], [2, 4], [3, 5], [4, 6]])
      end
    end

    context "when moving from 7,2 to 4,5" do
      it "returns the correct diagonal path" do
        from = [7, 2]
        to = [4, 5]
        result = test_queen.path(from, to)
        expect(result).to eql([[6, 3], [5, 4]])
      end
    end
  end

  describe "#adjacent_squares" do
    context "when at the center" do
      it "returns only valid squares" do
        square = [3, 3]
        result = test_queen.adjacent_squares(square)
        expect(result).to eql({
                                [4, 3] => [],
                                [5, 3] => [[4, 3]],
                                [6, 3] => [[4, 3], [5, 3]],
                                [7, 3] => [[4, 3], [5, 3], [6, 3]],
                                [3, 4] => [],
                                [3, 5] => [[3, 4]],
                                [3, 6] => [[3, 4], [3, 5]],
                                [3, 7] => [[3, 4], [3, 5], [3, 6]],
                                [2, 3] => [],
                                [1, 3] => [[2, 3]],
                                [0, 3] => [[2, 3], [1, 3]],
                                [3, 2] => [],
                                [3, 1] => [[3, 2]],
                                [3, 0] => [[3, 2], [3, 1]],
                                [4, 4] => [],
                                [5, 5] => [[4, 4]],
                                [6, 6] => [[4, 4], [5, 5]],
                                [7, 7] => [[4, 4], [5, 5], [6, 6]],
                                [4, 2] => [],
                                [5, 1] => [[4, 2]],
                                [6, 0] => [[4, 2], [5, 1]],
                                [2, 4] => [],
                                [1, 5] => [[2, 4]],
                                [0, 6] => [[2, 4], [1, 5]],
                                [2, 2] => [],
                                [1, 1] => [[2, 2]],
                                [0, 0] => [[2, 2], [1, 1]]
                              })
      end
    end
  end
end
