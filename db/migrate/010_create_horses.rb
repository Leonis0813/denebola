class CreateHorses < ActiveRecord::Migration[4.2]
  def change
    create_table :horses do |t|
      t.string :horse_id, null: false

      t.timestamps null: false
    end

    add_index :horses, %i[horse_id], unique: true
  end
end
