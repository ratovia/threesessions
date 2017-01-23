class Face < ApplicationRecord
  has_many :vertices, dependent: :destroy
  belongs_to :mesh, optional: true
  belongs_to :scene, optional: true
end
