class CreateRoomsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms_users ,id: false do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
