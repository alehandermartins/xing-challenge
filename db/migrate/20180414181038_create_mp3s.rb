class CreateMp3s < ActiveRecord::Migration[5.2]
  def change
    create_table :mp3s do |t|
      t.string :title
      t.string :interpret
      t.string :album
      t.integer :track
      t.integer :year
      t.string :genre

      t.timestamps
    end
  end
end
