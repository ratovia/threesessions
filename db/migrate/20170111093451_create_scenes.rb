class CreateScenes < ActiveRecord::Migration[5.0]
  def change
    create_table :scenes do |t|
      t.belongs_to :room
      t.integer :aff
      t.timestamps
    end
  end
end
