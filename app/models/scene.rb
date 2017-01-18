class Scene < ApplicationRecord
  belongs_to :room
  has_many :meshes
  has_many :faces
  has_many :vertices
end
