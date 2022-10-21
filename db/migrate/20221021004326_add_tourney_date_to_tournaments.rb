class AddTourneyDateToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :tourney_date, :date
  end
end
