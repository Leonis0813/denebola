class ChangeHorses < ActiveRecord::Migration[4.2]
  def up
    change_table :horses, bulk: true do |t|
      t.remove :last_race_final_600m_time
      t.remove :last_race_order
      t.remove :second_last_race_order
    end
  end

  def down
    change_table :horses, bulk: true do |t|
      t.float :last_race_final_600m_time, after: :horse_id
      t.integer :last_race_order, after: :last_race_final_600m_time
      t.integer :second_last_race_order, after: :last_race_order
    end
  end
end
