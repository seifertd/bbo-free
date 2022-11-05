require "test_helper"

class TournamentTest < ActiveSupport::TestCase
  test "can create a record" do
    tournament = create(:tournament)
    assert tournament.guid.present?
  end
  test "saving tournament saves all descendent objects" do
    tournament = build(:tournament)
    tournament.entries << build(:entry)
    tournament.entries.first.boards << build(:board)
    tournament.save!
    assert tournament.id.present?
    assert tournament.entries.all? { |e| e.id.present? && e.boards.all? {|b| b.id.present?} }
  end

  test "deleting tournament cleans up all children" do
    tournament = build(:tournament)
    tournament.entries << build(:entry)
    tournament.entries.first.boards << build(:board)
    tournament.save!
    tournament.destroy
    assert Board.count == 0
    assert Entry.count == 0
    assert Tournament.count == 0
  end

  test "score recalcualtion" do
    tournament = build(:tournament)
    num_entries = 10
    num_boards = 10
    entries = num_entries.times.map do |idx|
      build(:entry, player: "ENTRY #{idx}")
    end
    num_boards.times do 
      points = []
      while points.size < num_entries
        run_length = rand([4, num_entries - points.size + 1].min)
        score = rand(100)
        points.concat([score]*run_length)
      end
      entries.zip(points).each do |entry, pts|
        entry.boards << build(:board)
        entry.boards.last.points = pts
        tournament.entries << entry
      end
    end
    tournament.save!
    tournament.recalculate!
    num_boards.times do |b_idx|
      boards = entries.map{|e| e.boards[b_idx] }
      board_scores = {}
      boards.each do |b|
        assert b.score <= 100.0, "score should be less than 100.0"
        assert b.score >= 0.0, "score should be greater than 0.0"
        if board_scores[b.points].nil?
          board_scores[b.points] = b.score
        else
          assert_in_delta board_scores[b.points], b.score, 1e-5, "scores of matching points should be equal"
        end
      end
    end
    entries.each.with_index do |e, idx|
      calculated_avg = e.boards.map{|b| b.score}.sum(0.0) / e.boards.size
      assert_in_delta e.score, calculated_avg, 1e-5, "average board score should be correct. #{e.score} calculated: #{calculated_avg}"
    end
  end
end
