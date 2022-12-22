class ReturnPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(items, no_doc, current_channel)
    super({:page_size => 'A4', :margin => [100, 40, 30, 40]})
    @items = items
    @no_doc = no_doc
    @current_channel = current_channel
    return_number
    header
    line_items
    line_item_rows
    footer
  end

  def return_number
    indent 5 do
      bounding_box([0, cursor - 50], :width => 500) do
        text "NOTA RETUR DISPLAY", size: 15, style: :bold, align: :center
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
        draw_text("No Nota", :size => 8, :style => :bold, :at => [([bounds.left, bounds.top - 7]), 0])
        draw_text("Tanggal", :size => 8, :style => :bold, :at => [([bounds.left, bounds.top - 18]), 0])
        draw_text(":", :size => 8, :at => [([bounds.left + 80, bounds.top - 6.5]), 0])
        draw_text(":", :size => 8, :at => [([bounds.left + 80, bounds.top - 17.5]), 0])
        draw_text("RT#{@no_doc.upcase}", :size => 8, :at => [([bounds.left + 85, bounds.top - 7]), 0])
        draw_text("#{Date.today.strftime('%d-%m-%Y')}", :size => 8, :at => [([bounds.left + 85, bounds.top - 18]), 0])
        draw_text("Nama Pameran/Showroom", :size => 8, :style => :bold, :at => [([bounds.left + 280, bounds.top - 7]), 0])
        draw_text("Alamat", :size => 8, :style => :bold, :at => [([bounds.left  + 280, bounds.top - 18]), 0])
        draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left + 392, bounds.top - 7]), 0])
        draw_text(":", :size => 8, :style => :bold, :at => [([bounds.left  + 392, bounds.top - 18]), 0])
        draw_text("#{@current_channel.nama.upcase}", :size => 8, :at => [([bounds.left + 400, bounds.top - 7]), 0])
        draw_text("#{@current_channel.alamat}", :size => 8, :at => [([bounds.left  + 400, bounds.top - 18]), 0])
      end
    end
    move_down 20
  end

  def line_items
    move_down 30
    table line_item_rows, :width => 520 do
      row(0).font_style = :bold
      self.cell_style = { size: 5 }
      columns(1..3).align = :left
      self.cell_style = { :borders => [:top, :bottom, :left, :right] }
      self.header = true
      self.column_widths = {0 => 50, 1 => 160, 2 => 20, 3 => 20, 4 => 20, 5 => 20, 6 => 20, 7 => 60, 8 => 50, 9 => 50, 10 => 50}
    end
  end

  def line_item_rows
    [["No Barcode", "Nama Barang", "P", "L", "T", "Sat", "Qty", "Ex. SJ", "Alasan Diretur", "Kondisi Barang", "Tindak Lanjut"]] +
      @items.map do |item|
      [item.serial, item.nama, item.kode_barang[12..14], item.kode_barang[15..17], "", "PCS", item.qty_out, item.no_sj, "", "", ""]
    end
  end

  def footer
    move_down 10
    stroke do
      move_down 3
      horizontal_line(0, 523)
    end
    move_down 10
    bounding_box([0, cursor - 5], :width => 200) do
      indent 12 do
        text "Diserahkan Oleh,", :size => 8
        move_down 40
      end
      text "(___________________)", :size => 8
    end
    bounding_box([130, cursor + 59.5], :width =>150) do
      indent 10 do
        text "Disetujui Oleh,", :size => 8
        move_down 40
      end
      text "(_________________)", :size => 9
    end
    bounding_box([260, cursor + 60], :width =>150) do
      indent 10 do
        text "Dibawa Oleh,", :size => 8
        move_down 40
      end
      text "(_________________)", :size => 9
      move_down 5
      text "No Mobil : ", :size => 8
      move_down 10
    end
    bounding_box([390, cursor + 83.5], :width =>150) do
      indent 10 do
        text "Diterima Oleh,", :size => 8
        move_down 40
      end
      text "(_________________)", :size => 9
    end
    move_down 10
    bounding_box([0, cursor - 10], :width => 500) do
      indent 5 do
        text "*) Khusus untuk Retur Display Pameran, kolom 'Diserahkan' harus ditandatangani oleh Koordinator Bongkaran", :size => 5, :style => :italic
        move_down 3
      end
    end
    indent 10 do
      bounding_box([0, cursor - 10], :width => 100) do
        text "R1: Akunting Pusat", :size => 3
      end
      bounding_box([60, cursor + 4], :width => 100) do
        text "R2: Akunting Cabang", :size => 3
      end
      bounding_box([140, cursor + 4], :width => 100) do
        text "R3: Pameran/Showroom", :size => 3
      end
      bounding_box([230, cursor + 4], :width => 100) do
        text "R4: Sales/Sales Counter", :size => 3
      end
    end
  end
end
