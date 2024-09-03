class AddVisibilityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :visibility, :boolean, default: false
  end
end
