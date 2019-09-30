class CreatePayoffTables < ActiveRecord::Migration[4.2]
  def change
    create_table_wins
    create_table_shows
    create_table_bracket_quinellas
    create_table_quinellas
    create_table_quinella_places
    create_table_exactas
    create_table_trios
    create_table_trifectas
  end

  private

  def create_table_wins
    create_table :wins do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false
      t.integer :number, null: false

      t.references :race, null: false

      t.timestamps null: false
    end
  end

  def create_table_shows
    create_table :shows do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false
      t.integer :number, null: false

      t.references :race, null: false

      t.timestamps null: false
    end
  end

  def create_table_bracket_quinellas
    create_table :bracket_quinellas do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false
      t.integer :bracket_number1, null: false
      t.integer :bracket_number2, null: false

      t.references :race, null: false

      t.timestamps null: false
    end
  end

  def create_table_quinellas
    create_table :quinellas do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false
      t.integer :number1, null: false
      t.integer :number2, null: false

      t.references :race, null: false

      t.timestamps null: false
    end
  end

  def create_table_quinella_places
    create_table :quinella_places do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false
      t.integer :number1, null: false
      t.integer :number2, null: false

      t.references :race, null: false

      t.timestamps null: false
    end
  end

  def create_table_exactas
    create_table :exactas do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false
      t.integer :first_place_number, null: false
      t.integer :second_place_number, null: false

      t.references :race, null: false

      t.timestamps null: false
    end
  end

  def create_table_trios
    create_table :trios do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false
      t.integer :number1, null: false
      t.integer :number2, null: false
      t.integer :number3, null: false

      t.references :race, null: false

      t.timestamps null: false
    end
  end

  def create_table_trifectas
    create_table :trifectas do |t|
      t.float :odds, null: false
      t.integer :favorite, null: false
      t.integer :first_place_number, null: false
      t.integer :second_place_number, null: false
      t.integer :third_place_number, null: false

      t.references :race, null: false

      t.timestamps null: false
    end
  end
end
