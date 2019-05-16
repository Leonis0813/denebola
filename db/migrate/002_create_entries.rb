class CreateEntries < ActiveRecord::Migration[4.2]
  def change
    create_table :entries do |t|
      t.integer :age, null: false
      t.float :burden_weight, null: false
      t.integer :number, null: false
      t.float :weight

      t.references :race, after: :weight

      t.timestamps null: false
    end

    add_index :entries, %i[race_id number], unique: true
  end
end
