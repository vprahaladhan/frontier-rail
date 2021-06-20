class SetDefaultProvider < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :provider, :string, default: "none" 
  end
end
