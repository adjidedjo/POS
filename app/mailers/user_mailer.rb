class UserMailer < ApplicationMailer

  def transfer_items(tr, user)
    @transfer_item = tr
    mail(to: user, subject: "Transfer Items Between Channel Customer")
  end

  def rejected_cancel_order(alasan, no_so, user)
    @alasan = alasan
    @no_so = no_so
    mail(to: user, subject: "Rejected Request Cancel Order")
  end

  def approved_cancel_order(no_so, user)
    @no_so = no_so
    mail(to: user, subject: "Approved Request Cancel Order")
  end

  def pembatalan_order(alasan, no_so, channel, user)
    @alasan = alasan
    @no_so = no_so
    @channel = channel
    mail(to: user, subject: "Request Cancel Order")
  end

  def return_stock(recipient, nama, user)
    @user = user
    attachments["#{nama}.xml"] = File.read("#{Rails.root}/public/#{nama}.xml")
    mail(to: recipient, subject: "Return Stock from POS Application")
  end

  def order_pameran(recipient, nama, user, order, type)
    type == "RE" ? "REGULAR" : "CLEARANCE SALE"
    @order_head = Sale.find(order.first.sale_id)
    @order = order
    @user = user
    attachments["#{nama}.xml"] = File.read("#{Rails.root}/public/#{nama}.xml")
    mail(to: recipient, subject: "Sales Order #{type} from POS Application", cc: "aji.y@ras.co.id" )
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