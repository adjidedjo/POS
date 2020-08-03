class UserMailer < ApplicationMailer
  default from: "Royal Corporation <support@ras.co.id>"
  def transfer_items(tr, user)
    @transfer_item = tr
    mail(to: 'aji.y@ras.co.id', subject: "Transfer Items Between Channel Customer")
  end

  def rejected_cancel_order(alasan, no_so, user)
    @alasan = alasan
    @no_so = no_so
    mail(to: 'aji.y@ras.co.id', subject: "Rejected Request Cancel Order")
  end

  def approved_cancel_order(no_so, user)
    @no_so = no_so
    mail(to: 'aji.y@ras.co.id', subject: "Approved Request Cancel Order")
  end

  def pembatalan_order(alasan, no_so, channel, user)
    @alasan = alasan
    @no_so = no_so
    @channel = channel
    mail(to: 'aji.y@ras.co.id', subject: "Request Cancel Order")
  end

  def return_stock(recipient, nama, user)
    @user = user
    attachments["#{nama}.xml"] = File.read("#{Rails.root}/public/#{nama}.xml")
    mail(to: 'aji.y@ras.co.id', subject: "Return Stock from POS Application")
  end

  def order_pameran(sales)
    order_no = sales.no_sale.to_s.rjust(4, '0')
    @sales_items = sales.sale_items
    @alamat = sales.pos_ultimate_customer.alamat.upcase!
    @kota = sales.pos_ultimate_customer.kota.upcase!
    email = sales.pos_ultimate_customer.email
    # type == "RE" ? "REGULAR" : "CLEARANCE SALE"
    # @order = order
    # @user = user
    attachments["Invoice.pdf"] = PosPdf.new(sales, order_no).render
    mail(to: email, subject: "Order Confirmation")
  end

  def pelunasan(recipient, nama, user)
    @user = user
    attachments["#{nama}.xml"] = File.read("#{Rails.root}/public/#{nama}.xml")
    mail(to: 'aji.y@ras.co.id', subject: "Sales Order from POS Application")
  end

  def new_channel(recipient, channel, password, username)
    @username = username
    @password = password
    @channel = channel
    mail(to: 'aji.y@ras.co.id', subject: "Akses Login Point of Sales")
  end
end