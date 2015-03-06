class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  def get_kode_barang_from_serial
    kode_serial = StatusBarcode.find_by_serial(params[:kode_barang]).kode_barang
    @kode = Item.find_by_kode_barang(kode_serial).kode_barang
    @nama = Item.find_by_kode_barang(kode_serial).nama
    @element_id = params[:element_id]

    respond_to do |format|
      format.js
    end
  end

  # GET /sales GET /sales.json
  def index
    @sales = current_user.admin? ? Sale.all : Sale.where(user_id: current_user.id)
    @items = Item.all
  end

  # GET /sales/1 GET /sales/1.json
  def show
    order_no = @sale.no_sale.to_s.rjust(4, '0')
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
    @channels = Channel.all
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales POST /sales.json
  def create
    @sale = Sale.new(sale_params)
    @sale.user_id = current_user.id
    @sale.sale_items.each do |sale_item|
      sale_item.user_id = current_user.id
    end

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
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
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
    params.require(:sale).permit(:asal_so, :salesman_id, :nota_bene, :keterangan_customer, :venue_id, :spg, :customer, :phone_number, :hp1, :hp2, :alamat_kirim, :so_manual, :store_id, :channel_id, :tipe_pembayaran, :no_kartu, :no_merchant, :atas_nama, :nama_kartu, :netto, :pembayaran, :no_sale, :cara_bayar, sale_items_attributes: [:id, :kode_barang, :sale_id, :jumlah, :tanggal_kirim, :taken, :bonus, :serial, :nama_barang, :user_id, :_destroy])
  end
end
