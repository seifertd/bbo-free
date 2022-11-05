class AddEntriesCountToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :entries_count, :integer
  end
end
