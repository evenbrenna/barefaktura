class AddOptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mva_reg, :boolean, :default => false
    add_column :users, :foretaks_reg, :boolean, :default => false
  end
end
