class CreateMeshes < ActiveRecord::Migration[5.0]
  def change
    create_table :meshes do |t|
      t.string :uuid
      t.belongs_to :scene
      t.timestamps
    end
  end
end
