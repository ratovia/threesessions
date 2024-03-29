# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170111093451) do

  create_table "faces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uuid"
    t.integer  "mesh_id"
    t.integer  "scene_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mesh_id"], name: "index_faces_on_mesh_id", using: :btree
    t.index ["scene_id"], name: "index_faces_on_scene_id", using: :btree
  end

  create_table "meshes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uuid"
    t.integer  "scene_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scene_id"], name: "index_meshes_on_scene_id", using: :btree
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "room_id"
    t.integer "user_id"
    t.index ["room_id"], name: "index_rooms_users_on_room_id", using: :btree
    t.index ["user_id"], name: "index_rooms_users_on_user_id", using: :btree
  end

  create_table "scenes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "room_id"
    t.integer  "aff"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_scenes_on_room_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vertices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uuid"
    t.string   "component"
    t.float    "data",       limit: 24
    t.string   "pointer"
    t.integer  "face_id"
    t.integer  "scene_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["face_id"], name: "index_vertices_on_face_id", using: :btree
    t.index ["scene_id"], name: "index_vertices_on_scene_id", using: :btree
  end

  add_foreign_key "rooms_users", "rooms"
  add_foreign_key "rooms_users", "users"
end
