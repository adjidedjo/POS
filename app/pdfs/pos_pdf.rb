class PosPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(order, order_no)
    super({:page_size => 'A4'})
    @order = order
    stroke_bounds
    order_number
    header
    line_items
    second_header
    footer
  end

  def order_number
    indent 5 do
      bounding_box([0, cursor - 50], :width => 250) do
        text "Faktur", size: 20, style: :bold
      end
    end
    bounding_box([220, cursor + 70], :width => 100) do
      logo_path = "#{Rails.root}/app/assets/images/IMG.jpg"
      image logo_path, height: 70, width: 80
    end
    bounding_box([300, cursor + 70], :width => 250) do
      logo_path = "#{Rails.root}/app/assets/images/logo-ladyamericana.jpg"
      image logo_path, height: 70, width: 100
    end
    bounding_box([410, cursor + 70], :width => 250) do
      logo_path = "#{Rails.root}/app/assets/images/elite.jpg"
      image logo_path, height: 70, width: 100
    end
    stroke do
      move_down 5
      horizontal_line(0, 523)
    end
  end

  def header
    indent 5 do
      bounding_box([0, cursor - 10], :width => 250) do
        text "No SO       : #{@order.no_so}", :size => 10, :style => :bold
        move_down 5
        text "Tanggal     : #{@order.created_at.to_date.strftime('%d-%m-%Y')}", :size => 10, :style => :bold
        move_down 5
        text "Salesman  : #{@order.salesman.nil? ? "" : @order.salesman.nama}", :size => 10, :style => :bold
      end
    end
    bounding_box([250, cursor + 45], :width => 250) do
      text "No Dealer                   : #{@order.store.kode_customer}", :size => 10, :style => :bold
      move_down 5
      text "Pameran/Showroom : #{@order.store.nama}", :size => 10, :style => :bold
      move_down 5
      text "Periode Pameran       : #{ @order.store.from_period.nil? ? '' : @order.store.from_period.strftime('%d/%m/%Y')}-#{ @order.store.to_period.nil? ? '' : @order.store.to_period.strftime('%d/%m/%Y')}", :size => 10, :style => :bold
    end
  end

  def line_items
    move_down 20
    table line_item_rows, :width => 523 do
      row(0).font_style = :bold
      self.cell_style = { size: 8 }
      columns(1..3).align = :left
      self.cell_style = { :borders => [:top, :bottom] }
      self.header = true
      self.column_widths = {0 => 100, 1 => 180, 2 => 50, 3 => 30, 4 => 50, 5 => 68, 6 => 45}
    end
  end

  def line_item_rows
    [["Kode Barang", "Nama Barang", "Satuan", "Qty", "Bonus", "Tanggal Kirim", "Taken"]] +
      @order.sale_items.map do |item|
      [item.kode_barang, item.nama_barang, 'PCS', item.jumlah, (item.bonus? ? "Bonus" : "-"), item.tanggal_kirim.strftime("%d %B %Y"), item.taken? ? "Yes" : "No"]
    end
  end

  def second_header
    bounding_box([0, cursor - 10], :width => 250) do
      indent 5 do
        text "Nama Customer   : #{@order.customer}", :size => 10, :style => :bold
        move_down 5
        text "No Telp/HP            : #{@order.phone_number}, #{@order.hp1}, #{@order.hp2},", :size => 10, :style => :bold
        move_down 5
        text "Alamat Kirim          : #{@order.alamat_kirim}", :size => 10, :style => :bold
      end
    end
    cek_voucher = @order.voucher == 0
    bounding_box([350, cursor + 45], :width => 250) do
      text "Total       : Rp. ", :size => 10, :style => :bold
      unless cek_voucher
        move_down 5
        text "Voucher : Rp. ", :size => 10, :style => :bold
      end
      move_down 5
      text "Bayar     : Rp. ", :size => 10, :style => :bold
      move_down 5
      text "Sisa        : Rp. ", :size => 10, :style => :bold
    end
    size = cek_voucher ? 45 : 61.5
    bounding_box([250, cursor + size], :width => 250) do
      text "#{number_to_currency(@order.netto, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 10, :style => :bold, :align => :right
      unless cek_voucher
        move_down 5
        text "#{number_to_currency(@order.voucher, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 10, :style => :bold, :align => :right
      end
      move_down 5
      debit =  @order.payment_with_debit_card.jumlah.nil? ? 0 : @order.payment_with_debit_card.jumlah
      total_bayar = @order.pembayaran + debit + @order.payment_with_credit_cards.sum(:jumlah)
      text "#{number_to_currency(total_bayar, precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 10, :style => :bold, :align => :right
      move_down 5
      text "#{number_to_currency(((@order.netto-@order.voucher)-total_bayar), precision:0, unit: "", separator: ".", delimiter: ".")}", :size => 10, :style => :bold, :align => :right
    end

    stroke do
      move_down 20
      horizontal_line(0, 523)
    end
  end

  def footer
    bounding_box([0, cursor], :width => 150) do
      move_down 5
      indent 5 do
        text "Keterangan Pembayaran :", :size => 10, :style => :bold
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
      end
      move_down 15
      indent 5 do
        text "#{@order.cara_bayar == 'um' ? 'Uang Muka' : 'Lunas'}", :size => 10
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
      end
    end
    bounding_box([150, cursor + 43.5], :width => 373.4) do
      move_down 5
      indent 5 do
        text "Jenis Pembayaran :", :size => 10, :style => :bold
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
      end
      move_down 15
      indent 5 do
        if @order.tipe_pembayaran == 'tunai'
          text "#{@order.tipe_pembayaran}", :size => 9
        else
          text "#{@order.tipe_pembayaran}", :size => 9
          bounding_box([150, cursor + 19.5], :width => 300) do
            text "Debit   : #{@order.payment_with_debit_card.no_kartu.upcase}", :size => 9
            no_credit = []
            @order.payment_with_credit_cards.each do |cc|
              no_credit << cc.no_kartu
            end
            text "Kredit  : #{no_credit.join(' ').upcase}", :size => 9
          end
          bounding_box([200, cursor + 22.5], :width => 200) do
          end
        end
      end
      stroke do
        line(bounds.bottom_right, bounds.top_right)
        line(bounds.bottom_left, bounds.bottom_right)
      end
    end
    move_down 30
    indent 5 do
      text "Keterangan : #{@order.keterangan_customer}", :size => 10
    end
    move_down 10
    bounding_box([80, cursor - 5], :width => 200) do
      indent 30 do
        text "Pemesan,", :size => 10
        move_down 40
      end
      text "(___________________)", :size => 10
    end
    bounding_box([300, cursor + 62], :width => 200) do
      indent 30 do
        text "Sales,", :size => 10
        move_down 40
      end
      text "(___________________)", :size => 10
    end
    move_down 10
    bounding_box([0, cursor - 10], :width => 500) do
      indent 5 do
        text "Syarat Pemesanan (Khusus Direct Selling)  : ", :size => 6, :style => :italic
        move_down 5
        text "1. Batas waktu pemesanan barang adalah 90 hari dari tanggal Sales Order.", :size => 6, :style => :italic
        move_down 5
        text "2. Apabila dalam jangka waktu 90 hari barang tidak diambil dan tidak ada keterangan dari customer, maka pemesanan tersebut dianggap batal dan uang muka tidak dapat diambil kembali", :size => 6, :style => :italic
        move_down 5
        text "3. Harga pesanan tersebut dianggap mengikat (tidak dikenakan penyesuaian harga baru) apabila Customer telah membayar minimum 50% dari nota harga keseluruhan, dan tidak melebihi 90 hari sejak pemesanan barang.", :size => 6, :style => :italic
        move_down 5
        text "4. Jika warna kain yang dipesan sudah habis, maka PT. Royal Abadi Sejahtera berhak mengganti warna kain dengan kualitas yang setara.", :size => 6, :style => :italic
        move_down 5
        text "5. Pelunasan pada saat penyerahan barang harus dengan uang tunai. Pelunasan dengan BCA/Cek dianggap sah apabila dicairkan sebelum tanggal penyerahan barang.", :size => 6, :style => :italic
        move_down 5
        text "6. Jika Sales Order dibatalkan, maka uang muka tidak dapat diambil kembali.", :size => 6, :style => :italic
        move_down 5
        text "7. Menandatangani Sales Order ini berarti Customer telah setuju dengan syarat-syarat di atas.", :size => 6, :style => :italic
        move_down 5
      end
    end
    indent 10 do
      bounding_box([0, cursor - 10], :width => 100) do
        text "R1: Customer", :size => 5
      end
      bounding_box([60, cursor + 6], :width => 100) do
        text "R2: Sales Counter", :size => 5
      end
      bounding_box([140, cursor + 6], :width => 100) do
        text "R3: Accounting Pusat", :size => 5
      end
      bounding_box([230, cursor + 6], :width => 100) do
        text "R4: Accounting Cabang", :size => 5
      end
      bounding_box([330, cursor + 6], :width => 100) do
        text "R5: Arsip", :size => 5
      end
    end
  end
end
