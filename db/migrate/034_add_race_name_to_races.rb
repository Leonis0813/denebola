class AddRaceNameToRaces < ActiveRecord::Migration[4.2]
  def change
    add_column :races, :race_name, :string, null: false, after: :race_id
  end
end
