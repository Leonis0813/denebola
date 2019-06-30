class CreateResults < ActiveRecord::Migration[4.2]
  def change
    create_table :results do |t|
      t.string :order, null: false

      t.references :entry
      t.references :race

      t.timestamps null: false
    end

    add_index :results, %i[race_id entry_id], unique: true
  end
end
