class AddSexToEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :entries, :sex, :string, null: false, after: :number
  end
end
