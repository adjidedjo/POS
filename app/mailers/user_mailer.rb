class UserMailer < ApplicationMailer

  def order_pameran(recipient, nama, user)
    @user = user
    attachments["#{nama}.xml"] = File.read("#{Rails.root}/public/#{nama}.xml")
    mail(to: recipient, subject: "Sales Order from POS Application")
  end

  def pelunasan(recipient, nama, user)
    @user = user
    attachments["#{nama}.xml"] = File.read("#{Rails.root}/public/#{nama}.xml")
    mail(to: recipient, subject: "Sales Order from POS Application")
  end

  def new_channel(recipient, channel, password, username)
    @username = username
    @password = password
    @channel = channel
    mail(to: recipient, subject: "Akses Login Point of Sales")
  end
end