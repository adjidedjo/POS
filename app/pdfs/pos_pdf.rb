class PosPdf < Prawn::Document
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
        text "Sales Order", size: 20, style: :bold
        text "#{@order.store.branch.cabang}", size: 10
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
      bounding_box([0, cursor - 20], :width => 250) do
        text "No SO       : #{@order.no_so}", :size => 10, :style => :bold
        move_down 5
        text "Tanggal     : #{@order.created_at.to_date.strftime('%d-%m-%Y')}", :size => 10, :style => :bold
        move_down 5
        text "Salesman  : #{@order.salesman.nama}", :size => 10, :style => :bold
      end
    end
    bounding_box([250, cursor + 55], :width => 250) do
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
      self.column_widths = {0 => 100, 1 => 225, 2 => 50, 3 => 30, 4 => 50, 5 => 68}
    end
  end

  def line_item_rows
    [["Kode Barang", "Nama Barang", "Satuan", "Qty", "Bonus", "Tanggal Kirim"]] +
      @order.sale_items.map do |item|
      [item.kode_barang, item.nama_barang, 'PCS', item.jumlah, (item.bonus? ? "Bonus" : "-"), item.tanggal_kirim]
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
    bounding_box([250, cursor + 45], :width => 250) do
      text "Total       : #{@order.netto}", :size => 10, :style => :bold, :align => :right
      move_down 5
      text "Bayar      : #{@order.pembayaran}", :size => 10, :style => :bold, :align => :right
      move_down 5
      text "Sisa        : #{@order.netto-@order.pembayaran}", :size => 10, :style => :bold, :align => :right
    end

    stroke do
      move_down 20
      horizontal_line(0, 523)
    end
  end

  def footer
    move_down 10
    indent 5 do
      text "Keterangan Pembayaran :", :size => 11, :style => :bold
    end
    bounding_box([0, cursor - 10], :width => 100) do
      indent 5 do
        text "#{@order.cara_bayar == 'um' ? 'Uang Muka' : 'Lunas'}", :size => 10, :style => :bold
      end
    end
    bounding_box([150, cursor + 10], :width => 100) do
      text "Jenis Pembayaran :", :size => 10, :style => :bold
    end
    if @order.tipe_pembayaran == 'tunai'
      bounding_box([150, cursor - 10], :width => 100) do
        text "#{@order.tipe_pembayaran.capitalize}", :size => 10, :style => :bold
      end
    else
      bounding_box([150, cursor - 10], :width => 200) do
        text "Kartu : #{@order.nama_kartu.capitalize}", :size => 10, :style => :bold
        move_down 5
        text "Atas Nama : #{@order.atas_nama.capitalize}", :size => 10, :style => :bold
      end
      bounding_box([350, cursor + 33], :width => 200) do
        text "No Kartu : #{@order.no_kartu}", :size => 10, :style => :bold
        move_down 5
        text "Merchant : #{@order.no_merchant}", :size => 10, :style => :bold
      end
    end
    move_down 5
    indent 5 do
      text "Keterangan : #{@order.keterangan_customer}", :size => 10
    end
    move_down 5
    bounding_box([0, cursor - 5], :width => 200) do
      indent 5 do
        text "Pemesan  : ", :size => 10
        move_down 5
        text "Nama       : ", :size => 10
        move_down 5
        text "Tanggal    : ", :size => 10
      end
    end
    bounding_box([250, cursor + 45], :width => 200) do
      text "Pemesan  : ", :size => 10
      move_down 5
      text "Nama       : ", :size => 10
      move_down 5
      text "Tanggal    : ", :size => 10
    end
    move_down 10
    bounding_box([0, cursor - 10], :width => 500) do
      indent 5 do
        text "Syarat Pemesanan (Khusus Direct Selling)  : ", :size => 9, :style => :italic
        move_down 5
        text "1. Batas waktu pemesanan barang adalah 90 hari dari tanggal Sales Order.", :size => 9, :style => :italic
        move_down 5
        text "2. Apabila dalam jangka waktu 90 hari barang tidak diambil dan tidak ada keterangan dari customer, maka pemesanan tersebut dianggap batal dan uang muka tidak dapat diambil kembali", :size => 9, :style => :italic
        move_down 5
        text "3. Harga pesanan tersebut dianggap mengikat (tidak dikenakan penyesuaian harga baru) apabila Customer telah membayar minimum 50% dari nota harga keseluruhan, dan tidak melebihi 90 hari sejak pemesanan barang.", :size => 9, :style => :italic
        move_down 5
        text "4. Jika warna kain yang dipesan sudah habis, maka PT. Royal Abadi Sejahtera berhak mengganti warna kain denga kualitas yang setara.", :size => 9, :style => :italic
        move_down 5
        text "5. Pelunasan pada saat penyerahan barang harus dengan uang tunai. Pelunasan dengan BCA/Cek dianggap sah apabila dicairkan sebelum tanggal penyerahan barang.", :size => 9, :style => :italic
        move_down 5
        text "6. Jika Sales Order dibatalkan, maka uang muka tidak dapat diambil kembali.", :size => 9, :style => :italic
        move_down 5
        text "7. Menandatangani Sales Order ini berarti Customer telah setuju dengan syarat-syarat di atas.", :size => 9, :style => :italic
        move_down 5
      end
    end
    indent 10 do
      bounding_box([0, cursor - 10], :width => 100) do
        text "R1: Customer", :size => 8
      end
      bounding_box([60, cursor + 9], :width => 100) do
        text "R2: Sales Counter", :size => 8
      end
      bounding_box([140, cursor + 9], :width => 100) do
        text "R3: Accounting Pusat", :size => 8
      end
      bounding_box([230, cursor + 9], :width => 100) do
        text "R4: Accounting Cabang", :size => 8
      end
      bounding_box([330, cursor + 9], :width => 100) do
        text "R5: Arsip", :size => 8
      end
    end
  end
end
