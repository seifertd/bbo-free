class PopulateTournamentEntriesCount < ActiveRecord::Migration[7.0]
  def up
    Tournament.find_each do |tourney|
      Tournament.reset_counters(tourney.id, :entries)
    end
  end
end
