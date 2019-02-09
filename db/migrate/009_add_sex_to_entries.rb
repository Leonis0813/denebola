class AddSexToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :sex, :string, :null => false, :after => :age
  end
end
