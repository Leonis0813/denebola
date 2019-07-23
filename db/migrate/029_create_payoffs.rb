class CreatePayoffs < ActiveRecord::Migration[4.2]
  def change
    create_table :payoffs do |t|
      t.string :betting_ticket, null: false
      t.float :odds, null: false, default: 0.0

      t.references :race, null: false, after: :odds

      t.timestamps null: false
    end
  end
end
