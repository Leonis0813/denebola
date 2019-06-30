class AddLastRaceFinal600mTimeToHorsesAndFeatures < ActiveRecord::Migration[4.2]
  def change
    add_column :horses,
               :last_race_final_600m_time,
               :float,
               after: :id
    add_column :features,
               :last_race_final_600m_time,
               :float,
               after: :jockey
  end
end
