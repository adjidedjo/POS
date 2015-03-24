class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  def get_kode_barang_from_serial
    kode_serial = ExhibitionStockItem.find_by_serial_and_jumlah_and_store_id_and_checked_in(params[:kode_barang], 1, current_user.sales_promotion.store_id, true).kode_barang
    @kode = ExhibitionStockItem.find_by_kode_barang(kode_serial).kode_barang
    @nama = ExhibitionStockItem.find_by_kode_barang(kode_serial).nama
    @element_id = params[:element_id]

    respond_to do |format|
      format.js
    end
  end

  # GET /sales GET /sales.json
  def index
    @sales = current_user.role == 'supervisor' ? current_user.supervisor_exhibition.sales.where(cancel_order: false) : Sale.where(user_id: current_user.id, cancel_order: false)
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
      end
    end
  end

  # GET /sales/new
  def new
    @sale = Sale.new
    @sale.sale_items.build
    @sale.build_payment_with_debit_card
    2.times {@sale.payment_with_credit_cards.build}
    @channels = Channel.all
    @spg_transaksi = current_user.sales_promotion
    @spv_transaksi = current_user.sales_promotion.store.supervisor_exhibition
    @merchant = current_user.sales_promotion.store.merchants
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
  end

  # POST /sales POST /sales.json
  def create
    @sale = Sale.new(sale_params)
    @sale.user_id = current_user.id
    @sale.tipe_pembayaran = params[:tipe_pembayaran].join(';')
    @sale.sale_items.each do |sale_item|
      sale_item.user_id = current_user.id
    end
    @spg_transaksi = current_user.sales_promotion
    @spv_transaksi = current_user.sales_promotion.store.supervisor_exhibition
    @merchant = current_user.sales_promotion.store.merchants
    @sale.nama_kartu = current_user.sales_promotion.store.merchants.find_by_no_merchant(sale_params["no_merchant"]).nama if sale_params["tipe_pembayaran"] == 'kredit'

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
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
      if @sale.update(sale_params)
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
    if current_user.sales_promotion.store.supervisor_exhibition.user.valid_password?(params[:password])
      @sale.update_attributes!(cancel_order: true)
      respond_to do |format|
        format.html { redirect_to sales_url, notice: 'Sale was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      redirect_to sale_path(params[:sale]), alert: 'Password supervisor yang anda masukkan salah.'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params[:id])
    @channels = Channel.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sale_params
    params.require(:sale).permit(:asal_so, :salesman_id, :nota_bene, :keterangan_customer, :venue_id, :customer, :phone_number, :hp1, :hp2, :alamat_kirim, :so_manual, :store_id, :channel_id, :tipe_pembayaran, :no_kartu, :no_merchant, :atas_nama, :nama_kartu, :netto, :pembayaran, :no_sale, :cara_bayar, :email, :voucher, :sales_promotion_id, :supervisor_exhibition_id, :sisa, :netto_elite, :netto_lady, :tanggal_kirim, :kota, sale_items_attributes: [:id, :kode_barang, :sale_id, :jumlah, :tanggal_kirim, :taken, :bonus, :serial, :nama_barang, :user_id, :_destroy], payment_with_credit_cards_attributes: [:id, :no_merchant, :nama_kartu, :no_kartu, :atas_nama, :jumlah], payment_with_debit_card_attributes: [:id, :nama_kartu, :no_kartu, :atas_nama, :jumlah])
  end
end