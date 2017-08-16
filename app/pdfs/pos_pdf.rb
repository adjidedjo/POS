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
    bounding_box([0, cursor - 10], :width => 80) do
      indent 5 do
        draw_text("Invoice No", :size => 8, :style => :bold, :at => [([bounds.left, bounds.top - 7]), 0])
        draw_text("Date", :size => 8, :style => :bold, :at => [([bounds.left, bounds.top - 18]), 0])
        draw_text("Product Consultant", :size => 8, :style => :bold, :at => [([bounds.left, bounds.top - 28]), 0])
        draw_text(":", :size => 8, :at => [([bounds.left + 80, bounds.top - 6.5]), 0])
        draw_text(":", :size => 8, :at => [([bounds.left + 80, bounds.top - 17.5]), 0])
        draw_text(":", :size => 8, :at => [([bounds.left + 80, bounds.top - 27.5]), 0])
        draw_text("#{@order.no_so.upcase}", :size => 8, :at => [([bounds.left + 85, bounds.top - 7]), 0])
        draw_text("#{@order.created_at.to_date.strftime('%d-%m-%Y')}", :size => 8, :at => [([bounds.left + 85, bounds.top - 18]), 0])
        sp = SalesPromotion.find(@order.sales_promotion_id)
        draw_text("#{sp.nama.upcase}" + " / " + "#{sp.handphone.nil? ? '-' : sp.handphone}",
          :size => 8, :at => [([bounds.left + 85, bounds.top - 28]), 0])
        if @order.channel_customer.channel.channel == 'SHOWROOM'
          draw_text("Showroom", :size => 8, :style => :bold, :at => [([bounds.left + 325, bounds.top - 7]), 0])
          draw_text("Address", :size => 8, :style => :bold, :at => [([bounds.left  + 325, bounds.top - 18]), 0])
          draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left + 370, bounds.top - 7]), 0])
          draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left  + 370, bounds.top - 18]), 0])
          draw_text("#{@order.channel_customer.nama.titleize}", :size => 8, :at => [([bounds.left + 375, bounds.top - 7]), 0])
          #          draw_text("#{@order.showroom.address.titleize}", :size => 8, :at => [([bounds.left  + 400, bounds.top - 18]), 0])
          y_position = cursor - 12.5
          excess_text = text_box "#{@order.channel_customer.alamat.titleize}",
            :width => 140,
            :height => 500,
            :overflow => :truncate,
            :at => [375, y_position],
            :size => 8

          text_box excess_text,
            :width => 200,
            :at => [500,y_position-100]
        else
          draw_text("Exhibition", :size => 8, :style => :bold, :at => [([bounds.left + 325, bounds.top - 7]), 0])
          draw_text("Exhibition Period", :size => 8, :style => :bold, :at => [([bounds.left  + 325, bounds.top - 18]), 0])
          draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left + 392, bounds.top - 7]), 0])
          draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left  + 392, bounds.top - 18]), 0])
          draw_text("#{@order.channel_customer.nama.upcase}", :size => 8, :at => [([bounds.left + 400, bounds.top - 7]), 0])
          draw_text("#{ @order.channel_customer.dari_tanggal.nil? ? '' : @order.channel_customer.dari_tanggal.strftime('%d %b %Y')} - #{ @order.channel_customer.sampai_tanggal.nil? ? '' : @order.channel_customer.sampai_tanggal.strftime('%d %b %Y')}", :size => 8, :at => [([bounds.left  + 400, bounds.top - 18]), 0])
        end
      end
    end
    move_down 20
  end

  def line_items
    move_down 30
    table line_item_rows, :width => 523 do
      row(0).font_style = :bold
      self.cell_style = { size: 6 }
      columns(1..3).align = :left
      self.cell_style = { :borders => [:top, :bottom, :left, :right] }
      self.header = true
      self.column_widths = {0 => 50, 1 => 225, 2 => 50, 3 => 30, 4 => 50, 5 => 68, 6 => 50}
    end
  end

  def line_item_rows
    [["Serial", "Product Name", "Unit", "Qty", "Bonus", "Delivery Date", "Taken"]] +
      @order.sale_items.map do |item|
      [item.serial, item.nama_barang, 'PCS', item.jumlah, (item.bonus? ? "Bonus" : "-"), item.tanggal_kirim.strftime("%d %B %Y"), item.taken? ? "Yes" : "No"]
    end
  end

  def second_header
    bounding_box([0, cursor - 5], :width => 100) do
      indent 5 do
        move_down 2
        bounding_box([0, cursor], :width => 10, :height => 10) do
          indent 5 do
            draw_text("Customer Name", :size => 8, :style => :bold, :at => [([bounds.left - 5, bounds.top - 3]), 0])
            draw_text("Phone/Mobile", :size => 8, :style => :bold, :at => [([bounds.left - 5, bounds.top - 13]), 0])
            draw_text("Shipping Address", :size => 8, :style => :bold, :at => [([bounds.left - 5, bounds.top - 23]), 0])
            draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left + 70, bounds.top - 3]), 0])
            draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left + 70, bounds.top - 13]), 0])
            draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left + 70, bounds.top - 23]), 0])
            draw_text("#{@order.pos_ultimate_customer.nama.upcase}", :size => 8, :at => [([bounds.left + 75, bounds.top - 3.3]), 0])
            draw_text("#{@order.pos_ultimate_customer.no_telepon}, #{@order.pos_ultimate_customer.handphone}, #{@order.pos_ultimate_customer.handphone1}", :size => 8, :at => [([bounds.left + 75, bounds.top - 13.5]), 0])
            y_position = cursor - 18
            excess_text = text_box "#{@order.pos_ultimate_customer.alamat.upcase+". "+@order.pos_ultimate_customer.kota.to_s.upcase}",
              :width => 200,
              :height => 50,
              :overflow => :truncate,
              :at => [75, y_position],
              :size => 8

            text_box excess_text,
              :width => 300,
              :at => [100,y_position-100]
            draw_text("Total Payment", :size => 8, :style => :bold, :at => [([bounds.left + 320, bounds.top - 5]), 0])
            if @order.voucher > 0
              draw_text("Voucher", :size => 8, :style => :bold, :at => [([bounds.left + 320, bounds.top - 15]), 0])
            end
            draw_text("Total Paid", :size => 8, :style => :bold, :at => [([bounds.left + 320, bounds.top - 25]), 0])
            draw_text("Amount Due", :size => 8, :style => :bold, :at => [([bounds.left + 320, bounds.top - 35]), 0])
            draw_text(": Rp. ", :size => 8, :at => [([bounds.left + 380, bounds.top - 5]), 0])
            if @order.voucher > 0
              draw_text(": Rp. ", :size => 8, :at => [([bounds.left + 380, bounds.top - 15]), 0])
            end
            draw_text(": Rp. ", :size => 8, :at => [([bounds.left + 380, bounds.top - 25]), 0])
            draw_text(": Rp. ", :size => 8, :at => [([bounds.left + 380, bounds.top - 35]), 0])
            text_box "#{number_to_currency(@order.netto, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8,
              :at => [420, cursor + 1], :width => 60, :height => 50, :align => :right
            if @order.voucher > 0
              text_box "#{number_to_currency(@order.voucher, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8,
                :at => [420, cursor - 9], :width => 60, :height => 50, :align => :right
            end
            debit =  @order.payment_with_debit_cards.sum(:jumlah)
            transfer = @order.jumlah_transfer.nil? ? 0 : @order.jumlah_transfer
            total_bayar = @order.pembayaran + debit + @order.payment_with_credit_cards.sum(:jumlah)+transfer
            text_box "#{number_to_currency(total_bayar, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8,
              :at => [420, cursor - 19], :width => 60, :height => 50, :align => :right
            text_box "#{number_to_currency(@order.sisa, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 8, :at => [420, cursor - 29], :width => 60, :height => 50, :align => :right
          end
        end
      end
    end
    move_down 40
  end

  def footer
    bounding_box([0, cursor], :width => 100) do
      move_down 5
      indent 5 do
        bounding_box([0, cursor], :width => 100.4) do
          text "Payment Note :", :size => 8, :style => :bold
        end
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_left, bounds.top_left)
        line(bounds.top_left, bounds.top_right)
      end
    end

    bounding_box([0, cursor + 10], :width => 100, :height => 41) do
      indent 5 do
        move_down 15
        bounding_box([0, cursor], :width => 100.4) do
          text "#{@order.cara_bayar == 'um' ? 'Down Payment' : 'Paid'}", :size => 8
        end
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_left, bounds.top_left)
      end
    end

    bounding_box([100, cursor + 45.5], :width => 422) do
      move_down 5
      indent 5 do
        bounding_box([0, cursor], :width => 100.4) do
          text "Method of Payment :", :size => 8, :style => :bold
        end
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_left, bounds.top_left)
        line(bounds.top_left, bounds.top_right)
      end
      bounding_box([0, cursor - 1], :width => 100) do
        indent 5 do
          move_down 2
          bounding_box([0, cursor], :width => 100.4) do
            debit =  @order.payment_with_debit_cards.sum(:jumlah)
            text "Cash", :size => 6
            text "Transfer", :size => 6
            text "Debit Card", :size => 6
            text "Credit Card", :size => 6
          end
          bounding_box([50, cursor + 27.5], :width => 50.4) do
            debit =  @order.payment_with_debit_cards.sum(:jumlah)
            text ": Rp. ", :size => 6
            text ": Rp. ", :size => 6
            text ": Rp. ", :size => 6
            text ": Rp. ", :size => 6
          end
          bounding_box([0, cursor + 28], :width => 100.4) do
            debit =  @order.payment_with_debit_cards.sum(:jumlah)
            text "#{number_to_currency(@order.pembayaran, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 6,
              :align => :right
            text "#{number_to_currency(@order.jumlah_transfer.nil? ? 0 : @order.jumlah_transfer, precision:0, unit: "",
            separator: ".", delimiter: ".")}", :size => 6, :align => :right
            text "#{number_to_currency(debit, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 6, :align => :right
            text "#{number_to_currency(@order.payment_with_credit_cards.sum(:jumlah), precision:0, unit: "", separator: ".",
            delimiter: ".")}", :size => 6, :align => :right
          end
        end
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
        line(bounds.bottom_left, bounds.top_left)
      end
    end

    move_down 10
    indent 5 do
      text "Note : #{@order.keterangan_customer.upcase}", :size => 7
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
        text "1. Minimum down payment is 30% of the Total Invoice.", :size => 4, :style => :italic
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
