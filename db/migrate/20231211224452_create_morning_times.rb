class CreateMorningTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :morning_times do |t|
      t.string :m_time

      t.timestamps
    end
  end
end
