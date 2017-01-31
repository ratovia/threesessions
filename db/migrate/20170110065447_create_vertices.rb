class CreateVertices < ActiveRecord::Migration[5.0]
  def change
    create_table :vertices do |t|
      t.string :uuid
      t.string :component
      t.float :data
      t.string :pointer
      t.belongs_to :face
      t.belongs_to :scene
      t.timestamps
    end
  end
end
