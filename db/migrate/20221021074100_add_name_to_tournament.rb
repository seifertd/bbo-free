class AddNameToTournament < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :name, :string, limit: 256
  end
end
