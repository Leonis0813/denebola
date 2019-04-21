class AddHorseIdToEntries < ActiveRecord::Migration[4.2]
  def change
    add_reference :entries, :horse, :null => false, :after => :race_id
  end
end
