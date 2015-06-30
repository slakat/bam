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

ActiveRecord::Schema.define(version: 20150630065247) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "lastname",   limit: 255
    t.string   "rut",        limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",       limit: 255
  end

  create_table "causa_changes", force: :cascade do |t|
    t.date     "fecha"
    t.string   "old_value",     limit: 255
    t.string   "new_value",     limit: 255
    t.string   "atributo",      limit: 255
    t.string   "identificador", limit: 255
    t.string   "tipo",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "civil_causas", force: :cascade do |t|
    t.string   "rol",        limit: 255
    t.date     "date"
    t.string   "caratulado", limit: 255
    t.string   "tribunal",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link",       limit: 255
  end

  create_table "client_causas", force: :cascade do |t|
    t.integer  "general_causa_id", limit: 4
    t.integer  "client_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "lastname",   limit: 255
    t.string   "rut",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id", limit: 4
  end

  create_table "corte_causas", force: :cascade do |t|
    t.string "numero_ingreso",  limit: 255
    t.date   "fecha_ingreso"
    t.string "ubicacion",       limit: 255
    t.date   "fecha_ubicacion"
    t.string "corte",           limit: 255
    t.string "caratulado",      limit: 255
    t.string "link",            limit: 255
  end

  create_table "expediente_cortes", force: :cascade do |t|
    t.string   "corte",            limit: 255
    t.string   "libro",            limit: 255
    t.string   "rol_ing",          limit: 255
    t.string   "recurso",          limit: 255
    t.integer  "suprema_causa_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "expedientes", force: :cascade do |t|
    t.string   "rol_rit",        limit: 255
    t.string   "ruc",            limit: 255
    t.string   "fecha",          limit: 255
    t.string   "caratulado",     limit: 255
    t.string   "tribunal",       limit: 255
    t.integer  "corte_causa_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "general_causa_cortes", force: :cascade do |t|
    t.integer  "general_causa_id", limit: 4
    t.integer  "corte_id",         limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "general_causa_supremas", force: :cascade do |t|
    t.integer  "general_causa_id", limit: 4
    t.integer  "suprema_id",       limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "general_causas", force: :cascade do |t|
    t.integer  "causa_id",         limit: 4
    t.string   "causa_type",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "general_causa_id", limit: 4
  end

  create_table "laboral_causas", force: :cascade do |t|
    t.string "rit",        limit: 255
    t.string "ruc",        limit: 255
    t.date   "fecha"
    t.string "caratulado", limit: 255
    t.string "tribunal",   limit: 255
    t.string "link",       limit: 255
  end

  create_table "litigantes", force: :cascade do |t|
    t.string   "nombre",           limit: 255
    t.string   "rut",              limit: 255
    t.string   "persona",          limit: 255
    t.string   "participante",     limit: 255
    t.integer  "general_causa_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "movimientos", force: :cascade do |t|
    t.string   "dato1",      limit: 255
    t.string   "dato2",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procesal_causas", force: :cascade do |t|
    t.string "tribunal",             limit: 255
    t.string "tipo",                 limit: 255
    t.string "rol_interno",          limit: 255
    t.string "rol_unico",            limit: 255
    t.string "identificacion_causa", limit: 255
    t.string "estado",               limit: 255
    t.string "link",                 limit: 255
  end

  create_table "retiros", force: :cascade do |t|
    t.string   "cuaderno",       limit: 255
    t.string   "data_retiro",    limit: 255
    t.string   "estado",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "civil_causa_id", limit: 4
  end

  create_table "search_records", force: :cascade do |t|
    t.string   "query",        limit: 255
    t.string   "competencias", limit: 255
    t.string   "user",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "searches", force: :cascade do |t|
    t.string   "term",       limit: 255
    t.integer  "account_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suprema_causas", force: :cascade do |t|
    t.string "numero_ingreso",  limit: 255
    t.string "tipo_recurso",    limit: 255
    t.date   "fecha_ingreso"
    t.string "ubicacion",       limit: 255
    t.date   "fecha_ubicacion"
    t.string "corte",           limit: 255
    t.string "caratulado",      limit: 255
    t.string "link",            limit: 255
  end

  create_table "user_causas", force: :cascade do |t|
    t.integer  "general_causa_id", limit: 4
    t.integer  "account_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "not1",             limit: 4, default: 1
    t.integer  "not2",             limit: 4, default: 1
    t.integer  "not3",             limit: 4, default: 1
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
