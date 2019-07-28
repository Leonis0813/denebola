class CreateJockeys < ActiveRecord::Migration[4.2]
  def change
    create_table :jockeys do |t|
      t.string :jockey_id, null: false

      t.timestamps null: false
    end
  end
end
