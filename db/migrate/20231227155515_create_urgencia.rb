class CreateUrgencia < ActiveRecord::Migration[7.1]
  def change
    create_table :urgencia do |t|
      t.string :name

      t.timestamps
    end
  end
end
