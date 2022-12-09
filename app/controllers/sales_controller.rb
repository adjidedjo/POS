class SalesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show_sale, :destroy]
  before_action :set_sale, only: [:edit, :update]
  before_action :sale_after_printed, only: [:show, :destroy]
  before_action :get_current_user, only: [:new, :show, :edit, :update, :create]
  before_action :current_user_destroy, only: [:destroy]
  # after_action :save_pdf, only: [:create]
  after_action :send_whatsapp_notif, only: [:create]

  def save_pdf
    pdf = PosPdf.new(@sale, @sale.no_so)
    pdf.render_file(Rails.root.join('public', "#{@sale.no_so}.pdf"))
  end

  def send_whatsapp_notif
    nama= @sale.pos_ultimate_customer.nama
    notelp = @sale.pos_ultimate_customer.no_telepon.gsub!(/^0/, '62')
    img = @sale.channel_customer.nama
    pdf = PosPdf.new(@sale, @sale.no_so)
    pdf.render_file(Rails.root.join('public', "#{@sale.no_so}.pdf"))
    begin
      RestClient.post "https://icwaba.damcorp.id/whatsapp/sendHsm/so_img_001", {"to": "#{notelp}", "token": "#{API}",
        "param": ["#{nama}", "#{img}"], "header": {"type": "document", "data": "http://classicspringbed.com:1107/#{@sale.no_so}.pdf", "filename": "INVOICE"}}.to_json, {content_type: :json, accept: :json}
    rescue RestClient::ExceptionWithResponse => e
      self.description = "It didn't work"
    end
  end

  def stock_availability
    stock = ExhibitionStockItem.where(kode_barang: params[:kode_barang],
    channel_customer_id: current_user.channel_customer.id, checked_in: true)
    @element_id = params[:element_id]
    @request_order = params[:jumlah]
    @total_stock = stock.sum(:jumlah)
    @serial_item = stock.first.serial.present?

    respond_to do |format|
      format.js
    end
  end

  def items
    @sales = Item.order(:nama).search(params[:term])

    respond_to do |format|
      format.html
      format.json {render json: @sales.map(&:nama)}
    end
  end

  def get_kode_barang_from_nama
    kode_serial = Item.find_by_nama(params[:nama])
    @kode = kode_serial.kode_barang
    @nama = kode_serial.nama
    @harga = current_user.id == 102 ? kode_serial.harga : 0
    @point = kode_serial.point
    @element_id = params[:element_id]

    respond_to do |format|
      format.js
    end
  end

  def exhibition_stock
    @stock = ExhibitionStockItem.order(:serial).where("serial like ? and channel_customer_id = ? and checked_in = true and jumlah > 0",
      "%#{params[:term]}%", current_user.channel_customer.id)

    respond_to do |format|
      format.html
      format.json {render json: @stock.map(&:serial)}
    end
  end

  def get_second_mid_from_merchant
    @tenor = []
    Merchant.where(no_merchant: params[:merchant]).each do |nm|
      @tenor << [nm.tenor, nm.mid]
    end

    respond_to do |format|
      format.js
    end
  end

  def get_mid_from_merchant
    @tenor = []
    Merchant.where(no_merchant: params[:merchant]).each do |nm|
      @tenor << [nm.tenor, nm.mid]
    end

    respond_to do |format|
      format.js
    end
  end

  def get_kode_barang_from_serial
    kode_serial = ExhibitionStockItem.find_by_serial_and_jumlah_and_checked_in_and_checked_out_and_channel_customer_id(
      params[:kode_barang], 1, true, false, current_user.channel_customer.id).kode_barang
    @kode = ExhibitionStockItem.find_by_kode_barang(kode_serial).kode_barang
    @nama = ExhibitionStockItem.find_by_kode_barang(kode_serial).nama
    @element_id = params[:element_id]

    respond_to do |format|
      format.js
    end
  end

  # GET /sales GET /sales.json
  def index
    @channel_customer = current_user.channel_customer
    @sales = Sale.all.where(cancel_order: false, channel_customer_id: @channel_customer.id).where("created_at >= ?", 2.month.ago).order("created_at DESC")
    @items = Item.all
  end

  # GET /sales/1 GET /sales/1.json
  def show
    order_no = @sale.no_sale.to_s.rjust(4, '0')
    @get_spg = SalesPromotion.find(@sale.sales_promotion_id).present? ? SalesPromotion.find(@sale.sales_promotion_id) : 0
    @tipe_pembayaran = @sale.tipe_pembayaran.split(";")
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PosPdf.new(@sale, order_no)
        send_data pdf.render, filename: "#{@sale.no_so}",
          type: "application/pdf",
          disposition: "inline"
        @sale.update_attributes(printed: true)
      end
    end
  end

  def show_sale
    @sale = Sale.find(params[:id])
    if @sale.requested_cancel_order == true
      order_no = @sale.no_sale.to_s.rjust(4, '0')
      @get_spg = SalesPromotion.find(@sale.sales_promotion_id)
      @tipe_pembayaran = @sale.tipe_pembayaran.split(";")
      respond_to do |format|
        format.html
        format.pdf do
          pdf = PosPdf.new(@sale, order_no)
          send_data pdf.render, filename: "#{@sale.no_so}",
            type: "application/pdf",
            disposition: "inline"
          @sale.update_attributes(printed: true)
        end
      end
    else
      redirect_to root_path
    end
  end

  # GET /sales/new
  def new
    @sale = Sale.new
    #    @sale.sale_items.build
    #    @sale.build_payment_with_debit_card
    1.times {@sale.payment_with_debit_cards.build}
    2.times {@sale.payment_with_credit_cards.build}
    @channels = Channel.all
    @merchant = current_user.channel_customer.merchants.group([:nama, :no_merchant])
    @tenor = []
    @sales_promotion = current_user.channel_customer.sales_promotions
    @ultimate_customer = PosUltimateCustomer.order(:nama).map(&:nama)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit_by_confirmation
    if current_user.sales_promotion.store.supervisor_exhibition.user.valid_password?(params[:password])
      redirect_to edit_sale_path(params[:sale])
    else
      redirect_to sale_path(params[:sale]), alert: 'Password supervisor yang anda masukkan salah.'
    end
  end
  # GET /sales/1/edit

  def edit
    @channels = Channel.all
    @merchant = current_user.channel_customer.merchants.group([:nama, :no_merchant])
    @tenor = []
    @sales_promotion = current_user.channel_customer.sales_promotions
    @ultimate_customer = PosUltimateCustomer.order(:nama).map(&:nama)
  end

  # POST /sales POST /sales.json
  def create
    @sale = Sale.new(sale_params)
    @sale.channel_customer_id = current_user.channel_customer.id
    @sale.channel_id = current_user.channel_customer.channel.id
    @sale.tipe_pembayaran = params[:tipe_pembayaran].join(';')
    @merchant = current_user.channel_customer.merchants
    get_credit_card = sale_params["tipe_pembayaran"].split(";").include?('Credit Card') if sale_params["tipe_pembayaran"].present?
    @sale.nama_kartu = @merchant.find_by_no_merchant(sale_params["no_merchant"]).nama if get_credit_card == true

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.', turbolinks: true }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        @sales_promotion = current_user.channel_customer.sales_promotions
        @no_telepon = params[:sale].present? ? params[:sale][:no_telepon] : nil
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1 PATCH/PUT /sales/1.json
  def update
    respond_to do |format|
      if @sale.readonly?
        format.html { redirect_to @sale, alert: 'SO ini sudah di print, tidak bisa dirubah' }
      elsif @sale.update(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 DELETE /sales/1.json
  def destroy
    unless @sale.cancel_order?
      unless params[:hapus].present?
        @sale.channel_customer.supervisor_exhibitions.each do |se|
          UserMailer.approved_cancel_order(@sale.no_so, se.email).deliver_now
        end
      end
      @sale.update_attributes(cancel_order: true, alasan_cancel: params[:alasan_cancel])
      @sale.sale_items.each do |co_si|
        if co_si.serial.present?
          esi = ExhibitionStockItem.find_by_kode_barang_and_serial_and_checked_out(co_si.kode_barang, co_si.serial, false)
          ssah = StoreSalesAndStockHistory.where(channel_customer_id: current_user.channel_customer.id, keterangan: "S",
            sale_id: @sale.id, serial: co_si.serial).first
          ssah.destroy
          esi.update_attributes(jumlah: (co_si.jumlah + esi.jumlah))
        else
          ssah = StoreSalesAndStockHistory.where(kode_barang: co_si.kode_barang,
            channel_customer_id: current_user.channel_customer.id, keterangan: "S", sale_id: @sale.id)
          ssah.each do |ssah_loop|
            esi = ExhibitionStockItem.find_by_kode_barang_and_channel_customer_id_and_no_sj(co_si.kode_barang,
              current_user.channel_customer.id, ssah_loop.no_sj)
            esi.update_attributes(jumlah: (co_si.jumlah + esi.jumlah))
            ssah_loop.destroy
          end
        end
        co_si.update_attributes!(cancel: true, serial: "")
      end
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'SO Berhasil Di Cancel Order.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: 'SO yang akan dibatalkan sudah dinyatakan BATAL'
    end
  end

  def request_cancel_order
    @no_so = Sale.find(params[:sale])
    if User.find(current_user.id).valid_password?(params[:password])
      @alasan_cancel = params[:alasan_cancel]
      @channel = ChannelCustomer.find(Sale.find(params[:sale]).channel_customer_id)
      @no_so.sale_items.group_by(&:brand_id).keys.each do |group|
        UserMailer.pembatalan_order(@alasan_cancel, @no_so, @channel.nama, @channel.recipients.find_by_brand_id(group).sales_counter.email).deliver_now
      end
      @no_so.update_attributes!(requested_cancel_order: true, rejected: false)
      redirect_to @no_so
    else
      redirect_to sale_path(@no_so), alert: 'Password supervisor yang anda masukkan salah.'
    end
  end

  def rejected_cancel_order
    @sale = Sale.find(params[:id])
    @alasan = params[:alasan_reject]
    unless @sale.cancel_order? || @sale.rejected?
      @sale.channel_customer.supervisor_exhibitions.each do |se|
        UserMailer.rejected_cancel_order(@alasan, @sale.no_so, se.email).deliver_now
      end
      @sale.update_attributes!(rejected: true)
      redirect_to root_path, notice: 'SO yang akan di request sudah di REJECT'
    else
      redirect_to root_path, notice: 'SO yang akan dibatalkan sudah dinyatakan BATAL atau sudah di REJECT'
    end
  end

  private

  def get_current_user
    @user = current_user.store.nil? ? current_user.showroom : current_user.store
  end

  def current_user_destroy
    sale = Sale.find(params[:id])
    @user = current_user.nil? ? sale.channel_customer : current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params[:id])
    @channels = Channel.all
#    if @sale.printed == true
#      redirect_to root_path, alert: "SO yang anda akan rubah sudah di print."
#    end
  end

  def sale_after_printed
    @sale = Sale.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sale_params
    params.require(:sale).permit(:asal_so, :salesman_id, :nota_bene, :keterangan_customer, :venue_id,
      :so_manual, :store_id, :channel_id, :tipe_pembayaran, :no_merchant,
      :atas_nama, :nama_kartu, :netto, :pembayaran, :no_sale, :cara_bayar, :voucher, :sales_promotion_id, :sisa,
      :netto_elite, :netto_lady, :tanggal_kirim, :showroom_id, :channel_customer_id, :nama, :email, :alamat, :no_telepon,
      :handphone, :handphone1, :kota, :bank_account_id, :jumlah_transfer, :all_items_exported, :printed, :netto_serenity, :netto_royal,
      :netto_tech, :alasan_cancel, :nik, :nama_ktp, :alamat_ktp,
      sale_items_attributes: [:id, :kode_barang, :sale_id, :jumlah, :tanggal_kirim, :taken, :bonus, :serial,
        :nama_barang, :user_id, :_destroy, :keterangan, :price_list, :point],
      payment_with_credit_cards_attributes: [:id, :no_merchant, :nama_kartu, :no_kartu_kredit, :atas_nama, :jumlah, :tenor, :mid],
      payment_with_debit_cards_attributes: [:id, :nama_kartu, :no_kartu_debit, :atas_nama, :jumlah])
  end
end
