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

ActiveRecord::Schema.define(version: 2021_08_30_080310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "monuments", force: :cascade do |t|
    t.string "item"
    t.string "wlmid"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "itemlabel"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "itemdescription"
    t.string "wikipedia"
    t.boolean "with_photos"
    t.integer "photos_count"
    t.string "commons"
    t.string "uploadurl"
    t.string "regione"
    t.string "nonwlmuploadurl"
    t.boolean "hidden"
    t.datetime "enddate"
    t.boolean "duplicate", default: false
    t.string "city"
    t.string "address"
    t.boolean "tree", default: false
    t.boolean "noupload", default: false
    t.date "year"
    t.string "allphotos"
    t.string "city_item"
    t.integer "commonsphotos"
  end

  create_table "nophotos", force: :cascade do |t|
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "monuments"
    t.integer "with_commons"
    t.integer "with_image"
    t.integer "nowlm"
    t.string "regione"
    t.integer "cities"
    t.integer "cities_with_trees"
  end

  create_table "towns", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "item"
    t.string "disambiguation"
    t.string "visible_name"
    t.string "search_name"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "english_name"
    t.index ["name", "disambiguation"], name: "index_towns_on_name_and_disambiguation", unique: true
  end

end
