class CreateFaces < ActiveRecord::Migration[5.0]
  def change
    create_table :faces do |t|
      t.string :uuid
      t.belongs_to :mesh
      t.belongs_to :scene
      t.timestamps
    end
  end
end
