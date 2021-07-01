class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.belongs_to :train, index: true, foreign_key: true
      t.date :date
      t.integer :capacity

      t.timestamps
    end
  end
end
