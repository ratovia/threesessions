class Mesh < ApplicationRecord
  has_many :faces, dependent: :destroy
  belongs_to :scene, optional: true
end
