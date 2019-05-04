class AddRaceIdToRaces < ActiveRecord::Migration[4.2]
  def change
    add_column :races, :race_id, :string, null: false, after: :id
  end
end
