class AddHorseIdToEntries < ActiveRecord::Migration[4.2]
  def change
    add_reference :entries, :horse, after: :weight_diff
  end
end
