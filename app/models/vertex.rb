class Vertex < ApplicationRecord
  belongs_to :face,optional: true
  belongs_to :scene, optional: true
end