class CreateTrains < ActiveRecord::Migration[6.1]
  def change
    create_table :trains do |t|
      t.string :name
      t.string :from
      t.string :to
      t.integer :capacity

      t.timestamps
    end
  end
end
