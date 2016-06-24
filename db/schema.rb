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

ActiveRecord::Schema.define(version: 20160618214253) do

  create_table "acquittance_with_credit_cards", force: :cascade do |t|
    t.integer  "acquittance_id",  limit: 4
    t.string   "no_merchant",     limit: 255
    t.string   "no_kartu_kredit", limit: 255
    t.string   "tenor",           limit: 255
    t.string   "mid",             limit: 255
    t.string   "nama_kartu",      limit: 255
    t.string   "atas_nama",       limit: 255
    t.decimal  "jumlah",                      precision: 10, default: 0
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "nama_merchant",   limit: 255
  end

  create_table "acquittance_with_debit_cards", force: :cascade do |t|
    t.integer  "acquittance_id", limit: 4
    t.string   "nama_kartu",     limit: 255
    t.string   "no_kartu_debit", limit: 255
    t.string   "atas_nama",      limit: 255
    t.decimal  "jumlah",                     precision: 10, default: 0
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "acquittances", force: :cascade do |t|
    t.integer  "sale_id",             limit: 4
    t.string   "no_reference",        limit: 255
    t.string   "method_of_payment",   limit: 255
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.decimal  "cash_amount",                     precision: 10, default: 0
    t.decimal  "transfer_amount",                 precision: 10, default: 0
    t.integer  "bank_account_id",     limit: 4
    t.string   "no_so",               limit: 255
    t.integer  "channel_customer_id", limit: 4
    t.boolean  "exported",            limit: 1,                  default: false
    t.datetime "exported_at"
    t.integer  "exported_by",         limit: 4
    t.string   "no_pelunasan",        limit: 255
    t.string   "no_order",            limit: 255
  end

  create_table "adjusments", force: :cascade do |t|
    t.integer  "channel_customer_id", limit: 4
    t.string   "kode_barang",         limit: 255
    t.string   "jumlah",              limit: 255
    t.string   "alasan",              limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "serial",              limit: 255
    t.string   "nama_channel",        limit: 255
    t.string   "no_sj",               limit: 255
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "account_number", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "branches", force: :cascade do |t|
    t.string "idcabang", limit: 3,   null: false
    t.string "cabang",   limit: 100
    t.string "alamat1",  limit: 200
    t.string "alamat2",  limit: 200
    t.string "alias",    limit: 7
  end

  add_index "branches", ["idcabang"], name: "PK_tbIdCabang", unique: true, using: :btree

  create_table "brands", force: :cascade do |t|
    t.string "id_brand", limit: 50,              null: false
    t.string "brand",    limit: 50, default: "", null: false
  end

  add_index "brands", ["brand"], name: "merk", using: :btree
  add_index "brands", ["id_brand"], name: "id_merk", using: :btree

  create_table "channel_customers", force: :cascade do |t|
    t.string   "kode_channel_customer", limit: 255
    t.integer  "channel_id",            limit: 4
    t.string   "nama",                  limit: 255
    t.text     "alamat",                limit: 65535
    t.date     "dari_tanggal"
    t.date     "sampai_tanggal"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "kota",                  limit: 255
    t.integer  "user_id",               limit: 4
    t.string   "group",                 limit: 255
    t.integer  "address_number",        limit: 4
  end

  create_table "channels", force: :cascade do |t|
    t.string   "channel",    limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kode",       limit: 2
  end

  create_table "exhibition_stock_items", force: :cascade do |t|
    t.integer  "channel_customer_id", limit: 4
    t.string   "serial",              limit: 255
    t.string   "kode_barang",         limit: 255
    t.string   "nama",                limit: 255
    t.integer  "jumlah",              limit: 4
    t.integer  "stok_awal",           limit: 4
    t.string   "no_so",               limit: 255
    t.string   "no_pbj",              limit: 255
    t.string   "no_sj",               limit: 255
    t.date     "tanggal_sj"
    t.string   "sj_pusat",            limit: 255
    t.integer  "store_id",            limit: 4
    t.integer  "showroom_id",         limit: 4
    t.boolean  "checked",             limit: 1
    t.boolean  "checked_in",          limit: 1,   default: false
    t.integer  "checked_in_by",       limit: 4
    t.boolean  "checked_out",         limit: 1,   default: false
    t.integer  "checked_out_by",      limit: 4
    t.datetime "checked_out_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "stocking_type",       limit: 255
    t.float    "price_list",          limit: 24
  end

  add_index "exhibition_stock_items", ["kode_barang", "serial", "no_sj", "jumlah", "checked_in", "checked_out", "channel_customer_id"], name: "index_stock", using: :btree

  create_table "item_masters", force: :cascade do |t|
    t.string "kode_barang", limit: 250
    t.string "nama",        limit: 250
  end

  create_table "item_pos", primary_key: "kode_barang", force: :cascade do |t|
    t.string  "tipe",          limit: 50
    t.string  "produk",        limit: 255
    t.string  "kode",          limit: 10
    t.string  "ukuran",        limit: 3
    t.decimal "price_list",                precision: 10
    t.decimal "special_price",             precision: 10
    t.integer "diskon1",       limit: 4
    t.integer "diskon2",       limit: 4
    t.decimal "upgrade",                   precision: 10
    t.decimal "cashback",                  precision: 10
  end

  create_table "items", force: :cascade do |t|
    t.string  "kode_barang", limit: 255
    t.string  "nama",        limit: 255
    t.integer "brand_id",    limit: 4
    t.string  "jenis",       limit: 10
    t.decimal "harga",                   precision: 10
  end

  add_index "items", ["brand_id"], name: "brand_id", using: :btree
  add_index "items", ["kode_barang"], name: "kode_barang", using: :btree
  add_index "items", ["nama"], name: "nama", using: :btree

  create_table "merchants", force: :cascade do |t|
    t.string   "nama",                limit: 255
    t.string   "no_merchant",         limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "tenor",               limit: 255
    t.string   "mid",                 limit: 255
    t.integer  "channel_customer_id", limit: 4
  end

  create_table "netto_sale_brands", force: :cascade do |t|
    t.integer  "brand_id",   limit: 4
    t.integer  "sale_id",    limit: 4
    t.decimal  "netto",                precision: 10
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "payment_with_credit_cards", force: :cascade do |t|
    t.string   "no_merchant",     limit: 255
    t.string   "nama_kartu",      limit: 255
    t.string   "no_kartu_kredit", limit: 255
    t.string   "atas_nama",       limit: 255
    t.decimal  "jumlah",                      precision: 10, default: 0
    t.integer  "sale_id",         limit: 4
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "nama_merchant",   limit: 255
    t.string   "tenor",           limit: 255
    t.string   "mid",             limit: 255
    t.integer  "acquittance_id_", limit: 4
  end

  create_table "payment_with_debit_cards", force: :cascade do |t|
    t.string   "nama_kartu",     limit: 255
    t.string   "no_kartu_debit", limit: 255
    t.string   "atas_nama",      limit: 255
    t.decimal  "jumlah",                     precision: 10, default: 0
    t.integer  "sale_id",        limit: 4
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "acquittance_id", limit: 4
    t.string   "no_kartu",       limit: 255
  end

  create_table "pos_ultimate_customers", force: :cascade do |t|
    t.string   "nama",          limit: 255
    t.text     "alamat",        limit: 65535
    t.string   "email",         limit: 255
    t.string   "no_telepon",    limit: 255
    t.string   "handphone",     limit: 255,   default: "0"
    t.string   "handphone1",    limit: 255,   default: "0"
    t.string   "kode_customer", limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "kota",          limit: 255
  end

  add_index "pos_ultimate_customers", ["nama", "no_telepon", "kode_customer"], name: "index_customer", using: :btree

  create_table "recipients", force: :cascade do |t|
    t.integer  "sales_counter_id",    limit: 4
    t.integer  "channel_customer_id", limit: 4
    t.integer  "brand_id",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "retail_customers", force: :cascade do |t|
    t.string   "nama",       limit: 255
    t.string   "handphone",  limit: 255
    t.text     "alamat",     limit: 65535
    t.string   "kota",       limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "nama_toko",  limit: 255
  end

  create_table "retail_sale_items", force: :cascade do |t|
    t.string   "kode",               limit: 255
    t.string   "nama",               limit: 255
    t.integer  "jumlah",             limit: 4
    t.float    "harga",              limit: 24
    t.float    "retail_customer_id", limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "sale_items", force: :cascade do |t|
    t.integer  "sale_id",             limit: 4
    t.string   "kode_barang",         limit: 255
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.integer  "jumlah",              limit: 4,                  default: 0
    t.date     "tanggal_kirim"
    t.boolean  "taken",               limit: 1
    t.boolean  "bonus",               limit: 1
    t.string   "serial",              limit: 100
    t.string   "nama_barang",         limit: 200
    t.integer  "user_id",             limit: 4
    t.boolean  "exported",            limit: 1,                  default: false
    t.integer  "exported_by",         limit: 4
    t.datetime "exported_at"
    t.decimal  "price_list",                      precision: 10, default: 0
    t.integer  "brand_id",            limit: 4
    t.string   "ex_no_sj",            limit: 255
    t.string   "keterangan",          limit: 255
    t.boolean  "cancel",              limit: 1,                  default: false
    t.integer  "channel_customer_id", limit: 4
    t.string   "no_bukti_exported",   limit: 255
    t.string   "stocking_type",       limit: 255
  end

  add_index "sale_items", ["kode_barang", "taken", "serial", "channel_customer_id"], name: "index_sale_items", using: :btree

  create_table "sales", force: :cascade do |t|
    t.integer  "salesman_id",              limit: 4
    t.string   "nota_bene",                limit: 255
    t.text     "keterangan_customer",      limit: 65535
    t.string   "so_manual",                limit: 255
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.integer  "channel_id",               limit: 4
    t.integer  "store_id",                 limit: 4
    t.decimal  "netto",                                  precision: 10, default: 0
    t.decimal  "pembayaran",                             precision: 10, default: 0
    t.string   "tipe_pembayaran",          limit: 255
    t.string   "no_kartu",                 limit: 255
    t.integer  "no_sale",                  limit: 4
    t.string   "cara_bayar",               limit: 255
    t.string   "no_so",                    limit: 255
    t.integer  "user_id",                  limit: 4
    t.decimal  "voucher",                                precision: 10, default: 0
    t.decimal  "sisa",                                   precision: 10, default: 0
    t.boolean  "cancel_order",             limit: 1,                    default: false
    t.decimal  "netto_price_list",                       precision: 10, default: 0
    t.decimal  "netto_elite",                            precision: 10, default: 0
    t.decimal  "netto_lady",                             precision: 10, default: 0
    t.date     "tanggal_kirim"
    t.integer  "sales_promotion_id",       limit: 4
    t.integer  "showroom_id",              limit: 4
    t.integer  "channel_customer_id",      limit: 4
    t.integer  "pos_ultimate_customer_id", limit: 4
    t.integer  "bank_account_id",          limit: 4
    t.decimal  "jumlah_transfer",                        precision: 10, default: 0
    t.boolean  "all_items_exported",       limit: 1,                    default: false
    t.boolean  "printed",                  limit: 1,                    default: false
    t.boolean  "verified",                 limit: 1,                    default: false
    t.integer  "verified_by",              limit: 4
    t.datetime "verified_at"
    t.string   "nama_spg",                 limit: 255
    t.string   "no_order",                 limit: 255
    t.float    "netto_serenity",           limit: 24,                   default: 0.0
    t.float    "netto_royal",              limit: 24,                   default: 0.0
    t.float    "netto_tech",               limit: 24,                   default: 0.0
    t.text     "alasan_cancel",            limit: 65535
    t.float    "netto_pure",               limit: 24,                   default: 0.0
    t.boolean  "requested_cancel_order",   limit: 1,                    default: false
    t.boolean  "rejected",                 limit: 1,                    default: false
    t.string   "rejected_reason",          limit: 255
    t.boolean  "validated",                limit: 1,                    default: false
  end

  add_index "sales", ["so_manual", "tipe_pembayaran", "cara_bayar", "cancel_order", "sales_promotion_id", "channel_customer_id", "pos_ultimate_customer_id", "bank_account_id"], name: "index_sales", using: :btree

  create_table "sales_counters", force: :cascade do |t|
    t.string   "nama",       limit: 255
    t.string   "nik",        limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "branch_id",  limit: 4
  end

  create_table "sales_promotions", force: :cascade do |t|
    t.string   "nama",                limit: 255
    t.string   "email",               limit: 255
    t.string   "nik",                 limit: 255
    t.string   "regex",               limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "channel_customer_id", limit: 4
    t.string   "handphone",           limit: 255
    t.string   "handphone1",          limit: 255
  end

  create_table "salesmen", force: :cascade do |t|
    t.string "nama", limit: 50
    t.string "nik",  limit: 30
  end

  add_index "salesmen", ["nama"], name: "nama", unique: true, using: :btree

  create_table "search_sales", force: :cascade do |t|
    t.string   "keywords",              limit: 255
    t.integer  "channel_id",            limit: 4
    t.integer  "channel_customer_id",   limit: 4
    t.string   "cara_bayar",            limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.date     "dari_tanggal"
    t.date     "sampai_tanggal"
    t.string   "tampilkan_berdasarkan", limit: 255
  end

  create_table "showrooms", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "branch_id",   limit: 4
    t.string   "city",        limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",     limit: 4
    t.string   "stock_items", limit: 255
    t.integer  "channel_id",  limit: 4
    t.text     "address",     limit: 65535
  end

  create_table "status_barcodes", force: :cascade do |t|
    t.string  "kode_barang", limit: 250
    t.string  "serial",      limit: 250
    t.string  "status",      limit: 5
    t.integer "branch_id",   limit: 4
  end

  create_table "store_sales_and_stock_histories", force: :cascade do |t|
    t.integer  "exhibition_id",       limit: 4,   default: 0
    t.integer  "channel_customer_id", limit: 4
    t.string   "serial",              limit: 255
    t.string   "kode_barang",         limit: 255
    t.string   "nama",                limit: 255
    t.string   "no_sj",               limit: 255
    t.datetime "tanggal"
    t.integer  "user_id",             limit: 4
    t.integer  "showroom_id",         limit: 4
    t.integer  "sale_id",             limit: 4
    t.boolean  "printed",             limit: 1,   default: false
    t.integer  "qty_in",              limit: 4,   default: 0
    t.integer  "qty_out",             limit: 4,   default: 0
    t.string   "no_bukti_return",     limit: 255
    t.string   "keterangan",          limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "store_sales_and_stock_histories", ["kode_barang", "no_sj", "qty_in", "qty_out", "keterangan", "serial", "channel_customer_id", "sale_id"], name: "index_stock_log", using: :btree

  create_table "stores", force: :cascade do |t|
    t.integer  "channel_id",    limit: 4
    t.string   "nama",          limit: 255
    t.string   "kota",          limit: 255
    t.date     "from_period"
    t.date     "to_period"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "branch_id",     limit: 4
    t.string   "kode_customer", limit: 255
    t.string   "stock_items",   limit: 255
    t.string   "jenis_pameran", limit: 255
    t.text     "keterangan",    limit: 65535
    t.integer  "user_id",       limit: 4
  end

  create_table "supervisor_exhibitions", force: :cascade do |t|
    t.string   "nama",                limit: 255
    t.string   "email",               limit: 255
    t.string   "nik",                 limit: 255
    t.integer  "user_id",             limit: 4
    t.integer  "store_id",            limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "regex",               limit: 255
    t.integer  "channel_customer_id", limit: 4
    t.string   "handphone",           limit: 255
    t.string   "handphone1",          limit: 255
  end

  create_table "transfer_items", force: :cascade do |t|
    t.string   "tfnmr",      limit: 255
    t.string   "brg",        limit: 255
    t.string   "nbrg",       limit: 255
    t.integer  "jml",        limit: 4
    t.integer  "ash",        limit: 4
    t.string   "tsh",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "sn",         limit: 255
  end

  create_table "user_tracings", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.boolean  "action",     limit: 1
    t.string   "ip",         limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    limit: 255, default: "", null: false
    t.string   "encrypted_password",       limit: 255, default: "", null: false
    t.string   "reset_password_token",     limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",       limit: 255
    t.string   "last_sign_in_ip",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                    limit: 1
    t.string   "role",                     limit: 255
    t.integer  "supervisor_exhibition_id", limit: 4
    t.integer  "sales_promotion_id",       limit: 4
    t.integer  "branch_id",                limit: 4,   default: 0
    t.integer  "store_id",                 limit: 4,   default: 0
    t.string   "nama",                     limit: 255
    t.integer  "showroom_id",              limit: 4
    t.string   "username",                 limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "venue_name",  limit: 255
    t.string   "city",        limit: 255
    t.integer  "branch_id",   limit: 4
    t.date     "from_period"
    t.date     "to_period"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 65535
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "warehouse_admins", force: :cascade do |t|
    t.string   "nik",        limit: 255
    t.string   "nama",       limit: 255
    t.string   "email",      limit: 255
    t.string   "branch_id",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "warehouse_recipients", force: :cascade do |t|
    t.integer  "warehouse_admin_id",  limit: 4
    t.integer  "channel_customer_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

end
