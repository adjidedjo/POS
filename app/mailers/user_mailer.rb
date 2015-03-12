class UserMailer < ApplicationMailer

  def order_pameran(recipient, nama)
    attachments["#{nama}.xml"] = File.read("#{Rails.root}/public/#{nama}.xml")
    mail(to: recipient, subject: "Order Pameran")
  end
end