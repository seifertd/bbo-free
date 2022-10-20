class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.references :entry, null: false, foreign_key: true
      t.integer :number
      t.datetime :played_at
      t.string :north, limit: 128
      t.string :south, limit: 128
      t.string :east, limit: 128
      t.string :west, limit: 128
      t.string :result, limit: 16
      t.integer :points
      t.decimal :score
      t.string :movie_url, limit: 1024
      t.string :lin_url, limit: 1024
      t.string :traveller_url, limit: 1024
      t.string :lin_data, limit: 1024

      t.timestamps
    end
  end
end
