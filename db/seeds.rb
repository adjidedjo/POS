# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(username: "adminpos", email: "adminpos@ras.co.id", password: "admind6f8", role: "admin")

User.create!(username: "acc_bandung", email: "acc_bandung@ras.co.id", password: "accbandung", role: "accounting", branch_id: 2)
User.create!(username: "acc_narogong", email: "acc_narogong@ras.co.id", password: "accnarogong", role: "accounting", branch_id: 3)
User.create!(username: "acc_bali", email: "acc_bali@ras.co.id", password: "accbali", role: "accounting", branch_id: 4)
User.create!(username: "acc_medan", email: "acc_medan@ras.co.id", password: "accmedan", role: "accounting", branch_id: 5)
User.create!(username: "acc_surabaya", email: "acc_surabaya@ras.co.id", password: "accsurabaya", role: "accounting", branch_id: 7)
User.create!(username: "acc_semarang", email: "acc_semarang@ras.co.id", password: "accsemarang", role: "accounting", branch_id: 8)
User.create!(username: "acc_cirebon", email: "acc_cirebon@ras.co.id", password: "acccirebon", role: "accounting", branch_id: 9)
User.create!(username: "acc_yogyakarta", email: "acc_yogyakarta@ras.co.id", password: "accyogyakarta", role: "accounting", branch_id: 10)
User.create!(username: "acc_palembang", email: "acc_palembang@ras.co.id", password: "accpalembang", role: "accounting", branch_id: 11)
User.create!(username: "acc_lampung", email: "acc_lampung@ras.co.id", password: "acclampung", role: "accounting", branch_id: 13)
User.create!(username: "acc_roxy", email: "acc_roxy@ras.co.id", password: "accroxy", role: "accounting", branch_id: 18)
User.create!(username: "acc_makasar", email: "acc_makasar@ras.co.id", password: "accmakasar", role: "accounting", branch_id: 19)
User.create!(username: "acc_pekanbaru", email: "acc_pekanbaru@ras.co.id", password: "accpekanbaru", role: "accounting", branch_id: 20)
User.create!(username: "acc_jember", email: "acc_jember@ras.co.id", password: "accjember", role: "accounting", branch_id: 22)
User.create!(username: "acc_tangerang", email: "acc_tangerang@ras.co.id", password: "acctangerang", role: "accounting", branch_id: 23)
User.create!(username: "acc_yogya2", email: "acc_yogya2@ras.co.id", password: "accyogya2", role: "accounting", branch_id: 24)

BankAccount.create!(name: "PT. Lady Americana Indonesia", account_number: "1234567890")
BankAccount.create!(name: "PT. Royal Abadi Sejahtera", account_number: "0987654321")