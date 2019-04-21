class AddHorseIdToEntries < ActiveRecord::Migration[4.2]
  def change
    add_reference :entries, :horse, :after => :race_id
  end
end
