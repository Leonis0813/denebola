class CreateHorses < ActiveRecord::Migration[4.2]
  def change
    create_table :horses do |t|
      t.timestamps :null => false
    end
  end
end
