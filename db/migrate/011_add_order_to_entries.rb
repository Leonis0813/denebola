class AddOrderToEntries < ActiveRecord::Migration[4.2]
  def change
    drop_table :results
    add_column :entries, :order, :string, null: false, after: :jockey
  end
end
