class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :tournament, null: false, foreign_key: true
      t.string :player, limit: 128
      t.date :played_at
      t.decimal :score
      t.integer :rank

      t.timestamps
    end
  end
end
