# frozen_string_literal: true

require "./lib/piece/king"

describe King do
  subject(:test_king) { described_class.new("white") }

  describe "#valid_move?" do
    it "returns true from 2,2 to 2,1" do
      from = [2, 2]
      to = [2, 1]
      result = test_king.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns true from 7,5 to 6,5" do
      from = [7, 5]
      to = [6, 5]
      result = test_king.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns true from 4,2 to 3,3" do
      from = [4, 2]
      to = [3, 3]
      result = test_king.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns true from 7,5 to 6,4" do
      from = [7, 5]
      to = [6, 4]
      result = test_king.valid_move?(from, to)
      expect(result).to be true
    end

    it "returns false from 3,3 to 1,4" do
      from = [3, 3]
      to = [1, 4]
      result = test_king.valid_move?(from, to)
      expect(result).to be false
    end

    it "returns false from 3,3 to 5,5" do
      from = [3, 3]
      to = [5, 5]
      result = test_king.valid_move?(from, to)
      expect(result).to be false
    end

    it "returns false from 3,3 to 3,5" do
      from = [3, 3]
      to = [3, 5]
      result = test_king.valid_move?(from, to)
      expect(result).to be false
    end
  end

  describe "#adjacent_squares" do
    context "when at a corner" do
      it "returns only valid squares" do
        square = [7, 0]
        result = test_king.adjacent_squares(square)
        expect(result).to eql({
                                [7, 1] => [],
                                [6, 1] => [],
                                [6, 0] => []
                              })
      end
    end

    context "when at the center" do
      it "returns only valid squares" do
        square = [4, 3]
        result = test_king.adjacent_squares(square)
        expect(result).to eql({
                                [5, 3] => [],
                                [5, 4] => [],
                                [4, 4] => [],
                                [3, 4] => [],
                                [3, 3] => [],
                                [3, 2] => [],
                                [4, 2] => [],
                                [5, 2] => []
                              })
      end
    end
  end
end
