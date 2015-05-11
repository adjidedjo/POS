class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :get_current_user, only: [:new, :show, :edit, :update, :destroy, :create]

  def stock_availability
    stock = ExhibitionStockItem.where(kode_barang: params[:kode_barang],
      channel_customer_id: current_user.channel_customer.id, checked_in: true)
    @element_id = params[:element_id]
    @request_order = params[:jumlah]
    @total_stock = stock.sum(:jumlah)

    respond_to do |format|
      format.js
    end
  end

  def exhibition_stock
    @stock = ExhibitionStockItem.order(:serial).where("serial like ? and channel_customer_id = ? and checked_in = true",
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
    @sales = Sale.all
    @items = Item.all
  end

  # GET /sales/1 GET /sales/1.json
  def show
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
  end

  # GET /sales/new
  def new
    @sale = Sale.new
    #    @sale.sale_items.build
    @sale.build_payment_with_debit_card
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
    if User.find(current_user.id).valid_password?(params[:password])
      @sale.update_attributes(cancel_order: true)
      @sale.payment_with_debit_card.destroy!
      @sale.payment_with_credit_cards.each do |pwcc|
        pwcc.destroy!
      end
      @sale.sale_items.each do |co_si|
        if co_si.serial.present?
          esi = ExhibitionStockItem.find_by_kode_barang_and_serial_and_checked_out(co_si.kode_barang, co_si.serial, false)
          ssah = StoreSalesAndStockHistory.where(kode_barang: co_si.kode_barang, serial: co_si.serial).first
          esi.update_attributes(jumlah: (co_si.jumlah + esi.jumlah))
          ssah.destroy
        end
      end
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Sale was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      redirect_to sale_path(params[:sale]), alert: 'Password supervisor yang anda masukkan salah.'
    end
  end

  private

  def get_current_user
    @user = current_user.store.nil? ? current_user.showroom : current_user.store
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params[:id])
    @channels = Channel.all
    if @sale.printed == true
      redirect_to root_path, alert: "SO yang anda akan rubah sudah di print."
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sale_params
    params.require(:sale).permit(:asal_so, :salesman_id, :nota_bene, :keterangan_customer, :venue_id,
      :so_manual, :store_id, :channel_id, :tipe_pembayaran, :no_merchant,
      :atas_nama, :nama_kartu, :netto, :pembayaran, :no_sale, :cara_bayar, :voucher, :sales_promotion_id, :sisa,
      :netto_elite, :netto_lady, :tanggal_kirim, :showroom_id, :channel_customer_id, :nama, :email, :alamat, :no_telepon,
      :handphone, :handphone1, :kota, :bank_account_id, :jumlah_transfer, :all_items_exported, :printed,
      sale_items_attributes: [:id, :kode_barang, :sale_id, :jumlah, :tanggal_kirim, :taken, :bonus, :serial,
        :nama_barang, :user_id, :_destroy, :keterangan],
      payment_with_credit_cards_attributes: [:id, :no_merchant, :nama_kartu, :no_kartu_kredit, :atas_nama, :jumlah, :tenor, :mid],
      payment_with_debit_card_attributes: [:id, :nama_kartu, :no_kartu_debit, :atas_nama, :jumlah])
  end
end