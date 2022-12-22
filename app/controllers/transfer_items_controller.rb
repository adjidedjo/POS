class TransferItemsController < ApplicationController
  before_action :set_transfer_item, only: [:show, :edit, :update, :destroy]
  
  def print_transfer
    @doc_code = TransferItem.find_by_id(params[:id]).tfnmr
    @unprint_return = TransferItem.where(tfnmr: @doc_code)
    @current_channel = current_user.channel_customer
    @tujuan = ChannelCustomer.find_by_id(@unprint_return.first.tsh).nama
    
    
    respond_to do |format|
      format.html
      format.pdf do
        pdf = TransferPdf.new(@unprint_return, @doc_code, @current_channel, @tujuan)
        send_data pdf.render, filename: "#{@doc_code}",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  def get_showrooms
    @channel = ChannelCustomer.order(:nama).where("nama like ? and id != ?", "%#{params[:term]}%", current_user.channel_customer.id)

    respond_to do |format|
      format.html
      format.json {render json: @channel.map(&:nama)}
    end
  end

  def get_kode_from_nama
    kode_serial = ExhibitionStockItem.find_by_nama(params[:nama]).kode_barang
    @kode = ExhibitionStockItem.find_by_kode_barang(kode_serial).kode_barang
    @element_id = params[:element_id]

    respond_to do |format|
      format.js
    end
  end

  def get_nama_from_serial
    kode_serial = ExhibitionStockItem.find_by_serial(params[:serial]).kode_barang
    @kode = ExhibitionStockItem.find_by_kode_barang(kode_serial).kode_barang
    @nama = ExhibitionStockItem.find_by_kode_barang(kode_serial).nama
    @element_id = params[:element_id]

    respond_to do |format|
      format.js
    end
  end

  def find_serial_on_stock
    @stock = ExhibitionStockItem.order(:serial).where("serial like ? and channel_customer_id = ? and checked_in = true  and checked_out = false and jumlah > 0",
      "%#{params[:term]}%", current_user.channel_customer.id)

    respond_to do |format|
      format.html
      format.json {render json: @stock.map(&:serial)}
    end
  end

  def find_item_on_stock
    @stock = ExhibitionStockItem.order(:serial).where("nama like ? and channel_customer_id = ? and checked_in = true and jumlah > 0",
      "%#{params[:term]}%", current_user.channel_customer.id)

    respond_to do |format|
      format.html
      format.json {render json: @stock.map(&:nama)}
    end
  end

  # GET /transfer_items GET /transfer_items.json
  def index
    @transfer_items = TransferItem.where("created_at >= ? and ash = ?", 6.month.ago, current_user.channel_customer.id)
  end

  # GET /transfer_items/1 GET /transfer_items/1.json
  def show
  end

  # GET /transfer_items/new
  def new
    @transfer_item = TransferItem.new
  end

  # GET /transfer_items/1/edit
  def edit
  end

  # POST /transfer_items POST /transfer_items.json
  def create
    @transfer_item = TransferItem.new(transfer_item_params)

    respond_to do |format|
      if @transfer_item.save
        format.html { redirect_to transfer_items_url, notice: 'Barang Berhasil Terkirim.' }
        format.json { render :show, status: :created, location: @transfer_item }
        ChannelCustomer.find_by_user_id(current_user.id).warehouse_recipients.each do |receiper|
          UserMailer.transfer_items(@transfer_item, receiper.warehouse_admin.email)
        end
      else
        format.html { render :new }
        format.json { render json: @transfer_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfer_items/1 PATCH/PUT /transfer_items/1.json
  def update
    respond_to do |format|
      if @transfer_item.update(transfer_item_params)
        format.html { redirect_to @transfer_item, notice: 'Transfer item was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer_item }
      else
        format.html { render :edit }
        format.json { render json: @transfer_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfer_items/1 DELETE /transfer_items/1.json
  def destroy
    @transfer_item.destroy
    respond_to do |format|
      format.html { redirect_to transfer_items_url, notice: 'Transfer item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_transfer_item
    @transfer_item = TransferItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transfer_item_params
    params.require(:transfer_item).permit(:tfnmr, :brg, :nbrg, :jml, :ash, :tsh, :sn)
  end
end
