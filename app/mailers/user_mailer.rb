class UserMailer < ApplicationMailer

  def order_pameran(recipient, nama, user)
    @user = user
    attachments["#{nama}.xml"] = File.read("#{Rails.root}/public/#{nama}.xml")
    mail(to: recipient, subject: "Sales Order from POS Application")
  end
end