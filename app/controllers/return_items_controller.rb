class ReturnItemsController < ApplicationController
  before_action :get_store_id
  before_action :returned

  def cancel_returned_items
    if @returned.first.no_bukti_return.nil?
      @returned.each do |rt|
        if rt.serial.present?
          ExhibitionStockItem.find_by_serial(rt.serial).update_attributes!(checked_out: false)
        else
          esi = ExhibitionStockItem.find_by_kode_barang_and_channel_customer_id_and_no_sj(rt.kode_barang, rt.channel_customer_id, rt.no_sj)
          esi.update_attributes!(jumlah: (esi.jumlah + rt.qty_out))
        end
        rt.destroy!
      end
      redirect_to return_items_return_path, notice: 'Barang barang yang dinyatakan return sudah dibatalkan'
    else
      redirect_to return_items_return_path, alert: 'Barang barang yang akan dibatalkan sudah dikirim'
    end
  end

  def send_returned_items
    get_branch = Time.now.strftime("%d%m%Y%H%M%S")

    respond_to do |format|
      format.xml do
        stream = render_to_string(:template=>"return_items/show.xml.builder" )
        send_data(stream, :type=>"text/xml",:filename => "#{get_branch}.xml")
      end
    end
  end

  def show
    if @returned.present?
      @recipient = ChannelCustomer.find(@returned.first.channel_customer_id).warehouse_recipients
    end
  end

  def print_return
    @unprint_return = StoreSalesAndStockHistory.where(channel_customer_id: current_user.channel_customer.id, keterangan: "B", printed: false)
    @doc_code = "RT" + Digest::SHA1.hexdigest([Time.now, rand].join)[0..8]
    @current_channel = current_user.channel_customer

    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReturnPdf.new(@unprint_return, @doc_code, @current_channel)
        send_data pdf.render, filename: "#{@doc_code}",
          type: "application/pdf",
          disposition: "inline"
        @unprint_return.each do |rt|
          rt.update_attributes(printed: true)
        end
      end
    end
  end

  def return
    @return = ExhibitionStockItem.where("channel_customer_id = ? and checked_in = ? and checked_out = ? and jumlah > ?",
      current_user.channel_customer, true, false, 0).group(:kode_barang)
  end

  def process_return
    params[:return].each do |key, value|
      items = ExhibitionStockItem.where("kode_barang = ? and channel_customer_id = ? and checked_in = ?
and checked_out = ? and jumlah > 0", value["kode_barang"], current_user.channel_customer, true, false)
      items.each do |item|
        unless value["jumlah"].blank?
          jumlah_ret = (value["jumlah"].to_i > item.jumlah.to_i) ? (item.jumlah.to_i) : value["jumlah"].to_i
          item.update_attributes!(jumlah: (item.jumlah - jumlah_ret.to_i))
          StoreSalesAndStockHistory.create(channel_customer_id: current_user.channel_customer.id,
            kode_barang: item.kode_barang, nama: item.nama, tanggal: Time.now, qty_out: jumlah_ret.to_i, keterangan: "B",
            no_sj: item.no_sj, serial: item.serial)
          value["jumlah"] = value["jumlah"].to_i - jumlah_ret
        end
        break if value["jumlah"] == 0
      end
    end
    redirect_to return_items_return_path, notice: 'Jika barang sudah di cek, tetapi masih tampil. Silahkan scan sesuai serial dengan mengklik kode barang'
  end

  def return_by_serial
    @return_by_serial = ExhibitionStockItem.where("channel_customer_id = ? and checked_in = ? and checked_out = ?
and kode_barang = ? and jumlah > ?", current_user.channel_customer, true, false, params[:kode_barang], 0).all
  end

  def process_return_by_serial
    #    params[:return].each do |key, value|
    #      @item_selected = value["kode_barang"]
    #      item = ExhibitionStockItem.find_by_kode_barang_and_serial_and_store_id(value["kode_barang"], value["serial"], @user_store)
    #      item.update_attributes!(checked_out: true, checked_out_by: current_user.id) if item.present?
    #    end
    rc = ExhibitionStockItem.find(params[:return_ids])
    rc.each do |a|
      a.update_attributes!(checked_out: true, checked_out_by: current_user.id)
      StoreSalesAndStockHistory.create(channel_customer_id: current_user.channel_customer.id,
        kode_barang: a.kode_barang, nama: a.nama, tanggal: Time.now, qty_out: a.jumlah, keterangan: "B",
        no_sj: a.no_sj, serial: a.serial)
      @item_selected = a.kode_barang
    end
    redirect_to  return_items_return_by_serial_path(kode_barang: @item_selected)
  end

  def returned
    @returned = StoreSalesAndStockHistory.where(channel_customer_id: current_user.channel_customer.id, keterangan: "B", printed: false)
  end

  private

  def get_store_id
    @user_store = current_user.store.present? ? current_user.store.id : 0
    @user_showroom = current_user.showroom.present? ? current_user.showroom.id : 0
  end
end