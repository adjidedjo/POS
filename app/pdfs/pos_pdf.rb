class PosPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(order, order_no)
    super({:page_size => 'A4', :margin => [100, 40, 30, 40]})
    @order = order
    order_number
    header
    line_items
    second_header
    footer
  end

  def order_number
    indent 5 do
      bounding_box([0, cursor - 50], :width => 250) do
        text "INVOICE", size: 15, style: :bold
      end
    end
    stroke do
      move_down 3
      horizontal_line(0, 523)
    end
  end

  def header
    indent 5 do
      bounding_box([0, cursor - 5], :width => 250) do
        text "Invoice No                : #{@order.no_so}", :size => 8, :style => :bold
        move_down 3
        text "Date                          : #{@order.created_at.to_date.strftime('%d-%m-%Y')}", :size => 8, :style => :bold
        move_down 3
        text "Product Consultant : #{SalesPromotion.find(@order.sales_promotion_id).nama.capitalize}", :size => 8, :style => :bold
      end
    end
    bounding_box([250, cursor + 38], :width => 250) do
      move_down 3
      text "Exhibition             : #{@order.store.nama}", :size => 8, :style => :bold
      move_down 3
      text "Exhibition Period : #{ @order.store.from_period.nil? ? '' : @order.store.from_period.strftime('%d %b %Y')} - #{ @order.store.to_period.nil? ? '' : @order.store.to_period.strftime('%d %b %Y')}", :size => 8, :style => :bold
    end
  end

  def line_items
    move_down 20
    table line_item_rows, :width => 523 do
      row(0).font_style = :bold
      self.cell_style = { size: 6 }
      columns(1..3).align = :left
      self.cell_style = { :borders => [:top, :bottom, :left, :right] }
      self.header = true
      self.column_widths = {0 => 275, 1 => 50, 2 => 30, 3 => 50, 4 => 68, 5 => 50}
    end
  end

  def line_item_rows
    [["Product Name", "Unit", "Qty", "Bonus", "Delivery Date", "Taken"]] +
      @order.sale_items.map do |item|
      [item.nama_barang, 'PCS', item.jumlah, (item.bonus? ? "Bonus" : "-"), item.tanggal_kirim.strftime("%d %B %Y"), item.taken? ? "Yes" : "No"]
    end
  end

  def second_header
    bounding_box([0, cursor - 5], :width => 250) do
      indent 5 do
        text "Customer Name   : #{@order.customer}", :size => 8, :style => :bold
        move_down 3
        text "Phone/Mobile        : #{@order.phone_number}, #{@order.hp1}, #{@order.hp2},", :size => 8, :style => :bold
        move_down 3
        text "Shipping Address : #{@order.alamat_kirim+". "+@order.kota.to_s}", :size => 8, :style => :bold
      end
    end
    cek_voucher = @order.voucher == 0
    bounding_box([300, cursor + 35], :width => 250) do
      text "Total Payment     : Rp. ", :size => 8, :style => :bold
      unless cek_voucher
        move_down 3
        text "Voucher               : Rp. ", :size => 8, :style => :bold
      end
      move_down 3
      text "Total Paid            : Rp. ", :size => 8, :style => :bold
      move_down 3
      text "Amount Due        : Rp. ", :size => 8, :style => :bold
    end
    size = cek_voucher ? 35 : 47
    bounding_box([250, cursor + size], :width => 250) do
      text "#{number_to_currency(@order.netto, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8, :style => :bold, :align => :right
      unless cek_voucher
        move_down 3
        text "#{number_to_currency(@order.voucher, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8, :style => :bold, :align => :right
      end
      move_down 3
      debit =  @order.payment_with_debit_card.jumlah.nil? ? 0 : @order.payment_with_debit_card.jumlah
      total_bayar = @order.pembayaran + debit + @order.payment_with_credit_cards.sum(:jumlah)
      text "#{number_to_currency(total_bayar, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8, :style => :bold, :align => :right

      #      move_down 3
      #      text "#{number_to_currency(debit, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8, :style => :bold, :align => :right
      #      move_down 16
      #      @order.payment_with_credit_cards.each do |cc|
      #        move_down 3
      #        text "#{number_to_currency(cc.jumlah, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8, :style => :bold, :align => :right if cc.nama_kartu.present?
      #      end

      move_down 3
      text "#{number_to_currency(((@order.netto-@order.voucher)-total_bayar), precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8, :style => :bold, :align => :right
    end

    stroke do
      move_down 3
      horizontal_line(0, 523)
    end
  end

  def footer
    bounding_box([0, cursor], :width => 150) do
      move_down 3
      indent 5 do
        text "Payment Note :", :size => 8, :style => :bold
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_left, bounds.top_left)
      end
      move_down 15
      indent 5 do
        text "#{@order.cara_bayar == 'um' ? 'Down Payment' : 'Paid'}", :size => 7
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_left, bounds.top_left)
      end
    end
    bounding_box([150, cursor + 37], :width => 373.4) do
      indent 5 do
      move_down 4
        text "Method of Payment :", :size => 8, :style => :bold
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
      end
      indent 5 do
        move_down 3.5
        debit =  @order.payment_with_debit_card.jumlah.nil? ? 0 : @order.payment_with_debit_card.jumlah
        text "Cash               : Rp. #{number_to_currency(@order.pembayaran, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 6
        text "Debit Card      : Rp. #{number_to_currency(debit, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 6
        text "Credit Card     : Rp. #{number_to_currency(@order.payment_with_credit_cards.sum(:jumlah), precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 6
        bounding_box([200, cursor + 22.5], :width => 200) do
        end
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
      end
    end
    move_down 30
    indent 5 do
      text "Note : #{@order.keterangan_customer}", :size => 8
    end
    move_down 10
    bounding_box([80, cursor - 5], :width => 200) do
      indent 25 do
        text "Customer,", :size => 8
        move_down 40
      end
      text "(___________________)", :size => 8
    end
    bounding_box([300, cursor + 62], :width =>150) do
      indent 10 do
        text "Product Consultant,", :size => 8
        move_down 40
      end
      text "(___________________)", :size => 9
    end
    move_down 10
    bounding_box([0, cursor - 10], :width => 500) do
      indent 5 do
        text "Terms & Conditions  : ", :size => 5, :style => :italic
        move_down 3
        text "1. Minimum down payment is 20% of the Total Invoice.", :size => 4, :style => :italic
        move_down 3
        text "2. Order time limit is 90 days from the invoice date.", :size => 4, :style => :italic
        move_down 3
        text "3. If the products purchased are not delivered or there is no confirmation within 6 months after the invoice date, the order will be automatically cancelled and there is no refund of the down payment.", :size => 4, :style => :italic
        move_down 3
        text "4. There will be no price adjustment if the customers have paid a minimum of 50% of the invoice and do not exceed the order limit of 90 days.", :size => 4, :style => :italic
        move_down 3
        text "5. If there is no stock of the fabric colour ordered, the company has the right to change the fabric with the same quality material.", :size => 4, :style => :italic
        move_down 3
        text "6. The amount due when the goods are delivered must be paid in cash. The payment by cheque/transfer claimed as fully paid if the money has been received on the company's bank account before the time of delivery", :size => 4, :style => :italic
        move_down 3
        text "7. There will be no refund of the down payment..", :size => 4, :style => :italic
        move_down 3
        text "7. By signing this invoice, the customers is deemed to have agreed to the terms & conditions as mentioned above.", :size => 4, :style => :italic
        move_down 3
      end
    end
    indent 10 do
      bounding_box([0, cursor - 10], :width => 100) do
        text "R1: Customer", :size => 3
      end
      bounding_box([60, cursor + 4], :width => 100) do
        text "R2: Sales Counter", :size => 3
      end
      bounding_box([140, cursor + 4], :width => 100) do
        text "R3: Head Accounting", :size => 3
      end
      bounding_box([230, cursor + 4], :width => 100) do
        text "R4: Branch Accounting", :size => 3
      end
      bounding_box([330, cursor + 4], :width => 100) do
        text "R5: Archive", :size => 3
      end
    end
  end
end
