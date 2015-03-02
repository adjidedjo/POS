# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150302073037) do

  create_table "branches", force: :cascade do |t|
    t.string "idcabang", limit: 3,   null: false
    t.string "cabang",   limit: 100
    t.string "alamat1",  limit: 200
    t.string "alamat2",  limit: 200
    t.string "alias",    limit: 7
  end

  add_index "branches", ["idcabang"], name: "PK_tbIdCabang", unique: true, using: :btree

  create_table "channels", force: :cascade do |t|
    t.string   "channel",    limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "cabang_id",           limit: 4
    t.string   "kode_barang",         limit: 255
    t.string   "nama",                limit: 255
    t.integer  "brand_id",            limit: 4
    t.string   "jenis",               limit: 255
    t.string   "produk",              limit: 255
    t.string   "kain",                limit: 255
    t.string   "panjang",             limit: 255
    t.string   "lebar",               limit: 255
    t.decimal  "prev_harga",                      precision: 10
    t.decimal  "harga",                           precision: 10
    t.integer  "prev_discount_1",     limit: 4
    t.integer  "discount_1",          limit: 4
    t.integer  "prev_discount_2",     limit: 4
    t.integer  "discount_2",          limit: 4
    t.integer  "prev_discount_3",     limit: 4
    t.integer  "discount_3",          limit: 4
    t.integer  "prev_discount_4",     limit: 4
    t.integer  "discount_4",          limit: 4
    t.decimal  "prev_upgrade",                    precision: 10
    t.decimal  "upgrade",                         precision: 10
    t.decimal  "prev_cashback",                   precision: 10, default: 0
    t.decimal  "cashback",                        precision: 10, default: 0
    t.decimal  "prev_special_price",              precision: 10
    t.decimal  "special_price",                   precision: 10
    t.integer  "regional_id",         limit: 4
    t.boolean  "additional_program",  limit: 1,                  default: false
    t.integer  "additional_diskon",   limit: 4,                  default: 0
    t.datetime "program_starting_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_items", force: :cascade do |t|
    t.integer  "sale_id",       limit: 4
    t.string   "kode_barang",   limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "jumlah",        limit: 4
    t.date     "tanggal_kirim"
    t.boolean  "taken",         limit: 1
    t.string   "bonus",         limit: 10
    t.string   "serial",        limit: 100
    t.string   "nama_barang",   limit: 200
    t.string   "no_so",         limit: 255
    t.string   "no_ppb",        limit: 255
    t.string   "no_faktur",     limit: 255
    t.string   "nos_sj",        limit: 255
  end

  create_table "sales", force: :cascade do |t|
    t.string   "asal_so",             limit: 255
    t.integer  "salesman_id",         limit: 4
    t.string   "nota_bene",           limit: 255
    t.text     "keterangan_customer", limit: 65535
    t.integer  "venue_id",            limit: 4
    t.string   "spg",                 limit: 255
    t.string   "customer",            limit: 255
    t.string   "phone_number",        limit: 255
    t.string   "hp1",                 limit: 255
    t.string   "hp2",                 limit: 255
    t.text     "alamat_kirim",        limit: 65535
    t.string   "so_manual",           limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "channel_id",          limit: 4
    t.integer  "store_id",            limit: 4
    t.decimal  "netto",                             precision: 10
    t.decimal  "pembayaran",                        precision: 10
    t.string   "tipe_pembayaran",     limit: 255
    t.string   "nama_kartu",          limit: 255
    t.string   "no_kartu",            limit: 255
    t.string   "no_merchant",         limit: 255
    t.string   "atas_nama",           limit: 255
    t.integer  "no_sale",             limit: 4
    t.string   "cara_bayar",          limit: 255
  end

  create_table "salesmen", force: :cascade do |t|
    t.string "nama", limit: 50
    t.string "nik",  limit: 30
  end

  add_index "salesmen", ["nama"], name: "nama", unique: true, using: :btree

  create_table "showrooms", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "branch_id",  limit: 4
    t.string   "city",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "stores", force: :cascade do |t|
    t.integer  "channel_id",    limit: 4
    t.string   "nama",          limit: 255
    t.string   "kota",          limit: 255
    t.date     "from_period"
    t.date     "to_period"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "branch_id",     limit: 4
    t.string   "kode_customer", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  limit: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "venue_name",  limit: 255
    t.string   "city",        limit: 255
    t.integer  "branch_id",   limit: 4
    t.date     "from_period"
    t.date     "to_period"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
