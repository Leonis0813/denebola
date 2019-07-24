class CreatePayoffTables < ActiveRecord::Migration[4.2]
  def change
    create_table :wins do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false

      t.references :race, null: false
      t.references :entry, null: false

      t.timestamps null: false
    end

    create_table :shows do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false

      t.references :race, null: false
      t.references :entry, null: false

      t.timestamps null: false
    end

    create_table :bracket_quinellas do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false

      t.references :race, null: false
      t.references :entry1, null: false, foreign_key: {to_table: :entries}
      t.references :entry2, null: false, foreign_key: {to_table: :entries}

      t.timestamps null: false
    end

    create_table :quinellas do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false

      t.references :race, null: false
      t.references :entry1, null: false, foreign_key: {to_table: :entries}
      t.references :entry2, null: false, foreign_key: {to_table: :entries}

      t.timestamps null: false
    end

    create_table :quinella_places do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false

      t.references :race, null: false
      t.references :entry1, null: false, foreign_key: {to_table: :entries}
      t.references :entry2, null: false, foreign_key: {to_table: :entries}

      t.timestamps null: false
    end

    create_table :exactas do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false

      t.references :race, null: false
      t.references :first_place, null: false, foreign_key: {to_table: :entries}
      t.references :second_place, null: false, foreign_key: {to_table: :entries}

      t.timestamps null: false
    end

    create_table :trios do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false

      t.references :race, null: false
      t.references :entry1, null: false, foreign_key: {to_table: :entries}
      t.references :entry2, null: false, foreign_key: {to_table: :entries}
      t.references :entry3, null: false, foreign_key: {to_table: :entries}

      t.timestamps null: false
    end

    create_table :trifectas do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false

      t.references :race, null: false
      t.references :first_place, null: false, foreign_key: {to_table: :entries}
      t.references :second_place, null: false, foreign_key: {to_table: :entries}
      t.references :third_place, null: false, foreign_key: {to_table: :entries}

      t.timestamps null: false
    end
  end
end
