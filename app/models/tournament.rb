class Tournament < ApplicationRecord
  attr_accessor :results
  has_many :entries, inverse_of: :tournament

  def recalculate!
    entries = self.entries
    max_score = 2.0 * (entries.size - 1)
    boards = entries.first.boards
    boards.each.with_index do |board, b_idx|
      points = entries.map.with_index do |entry, e_idx|
        board_entry = entry.boards[b_idx]
        [board_entry.points, e_idx]
      end.sort_by do |tuple|
        -tuple[0]
      end
      points.each.with_index do |tuple, place|
        if tuple.size == 3
          next
        end
        memo = [place, points.size - place - 1, (points.size - place - 1) * 2.0 / max_score * 100.0 ]
        tuple << memo
        next_ind = place + 1
        while next_ind < points.size && tuple[0] == points[next_ind][0]
          memo[1] -= 1
          memo[2] = (memo[1] * 2.0 + (points.size - (memo[0] + memo[1])) * 0.5) / max_score * 100.0
          points[next_ind] << memo
          next_ind += 1
        end
      end
      points.each.with_index do |tuple, idx|
        entries[tuple[1]].boards[b_idx].update(score: tuple[2][2])
        if b_idx == 0
          entries[tuple[1]].score = tuple[2][2]
        else
          entries[tuple[1]].score = ( entries[tuple[1]].score * b_idx + tuple[2][2] ) / (b_idx + 1)
        end
      end
    end
    entries.sort_by(&:score).reverse.each.with_index do |entry, rank|
      entry.rank = rank + 1
      entry.save!
    end
  end
end
