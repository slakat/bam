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

ActiveRecord::Schema.define(version: 20150409155535) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "lastname"
    t.string   "rut"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "civil_causas", force: true do |t|
    t.string   "rol"
    t.date     "date"
    t.string   "caratulado"
    t.string   "tribunal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_causas", force: true do |t|
    t.integer  "causa_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "lastname"
    t.string   "rut"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corte_causas", force: true do |t|
    t.string "numero_ingreso"
    t.date   "fecha_ingreso"
    t.string "ubicacion"
    t.date   "fecha_ubicacion"
    t.string "corte"
    t.string "caratulado"
  end

  create_table "general_causas", force: true do |t|
    t.integer  "causa_id"
    t.string   "causa_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "laboral_causas", force: true do |t|
    t.string "rit"
    t.string "ruc"
    t.date   "fecha"
    t.string "caratulado"
    t.string "tribunal"
  end

  create_table "movimientos", force: true do |t|
    t.string   "dato1"
    t.string   "dato2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procesal_causas", force: true do |t|
    t.string "tribunal"
    t.string "tipo"
    t.string "rol_interno"
    t.string "rol_unico"
    t.string "identificacion_causa"
    t.string "estado"
  end

  create_table "retiros", force: true do |t|
    t.string   "cuaderno"
    t.string   "data_retiro"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", force: true do |t|
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suprema_causas", force: true do |t|
    t.string "numero_ingreso"
    t.string "tipo_recurso"
    t.date   "fecha_ingreso"
    t.string "ubicacion"
    t.date   "fecha_ubicacion"
    t.string "corte"
    t.string "caratulado"
  end

  create_table "user_causas", force: true do |t|
    t.integer  "causa_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
