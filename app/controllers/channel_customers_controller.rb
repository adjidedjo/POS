class ChannelCustomersController < ApplicationController
  before_action :set_channel_customer, only: [:show, :edit, :update, :destroy]

  def proses_import_intransit
    tempfile = File.read(params[:stock_items].tempfile)
    channel_customer = current_user.channel_customer.id
    #    tempfile = File.read(tempfile)
    doc = Nokogiri::XML(tempfile)
    item = doc.xpath("data/pameran")
    @a = []
    item.each do |si|
      si_hash = {
        kode_barang: si.at_xpath("KodeBrg").text,
        nama: si.at_xpath("Nama").text,
        serial: ((si.at_xpath("Serial").text.length > 5) ? si.at_xpath("Serial").text : ''),
        no_so: si.at_xpath("NoSO").text,
        no_pbj: si.at_xpath("NoPBJ").text,
        no_sj: si.at_xpath("NoSJ").text,
        tanggal_sj: si.at_xpath("TglSJ").text.to_date,
        channel_customer_id: channel_customer,
        store_id: 0,
        jumlah: ((si.at_xpath("Serial").text.length <= 5) ? si.at_xpath("Serial").text : 1)
      }
      item_hash = {
        kode_barang: si.at_xpath("KodeBrg").text,
        nama: si.at_xpath("Nama").text
      }
      @kode_channel_customer_hash = {
        kode_channel_customer: si.at_xpath("KodePameran").text,
      }
      ExhibitionStockItem.where(kode_barang: si_hash[:kode_barang], serial: si_hash[:serial], no_sj: si_hash[:no_sj], channel_customer_id: current_user.channel_customer.id).first_or_create(si_hash)
      Item.where(kode_barang: si_hash[:kode_barang]).first_or_create(item_hash)
    end
    current_user.channel_customer.update_attributes!(kode_channel_customer: @kode_channel_customer_hash[:kode_channel_customer]) if current_user.channel_customer.kode_channel_customer.blank?

    respond_to do |format|
      format.html { redirect_to current_user.channel_customer, notice: 'Intransit sudah berhasil di upload.' }
      format.json { render :show, status: :created, location: @showroom }
    end
  end

  def import_intransit
  end

  # GET /channel_customers
  # GET /channel_customers.json
  def index
    @channel_customers = ChannelCustomer.all
    @cc = ChannelCustomer.order(:nama).where("nama like ?", "%#{params[:term]}%")

    respond_to do |format|
      format.html
      format.json {render json: @cc.map(&:nama)}
    end
  end

  # GET /channel_customers/1
  # GET /channel_customers/1.json
  def show
    user = current_user.admin? ? @channel_customer : current_user.channel_customer
    @supervisors = user.supervisor_exhibitions
    @merchants = user.merchants
    @sales_promotions = user.sales_promotions
  end

  # GET /channel_customers/new
  def new
    @channel_customer = ChannelCustomer.new
    @channel = Channel.all
  end

  # GET /channel_customers/1/edit
  def edit
  end

  # POST /channel_customers
  # POST /channel_customers.json
  def create
    @channel_customer = ChannelCustomer.new(channel_customer_params)

    respond_to do |format|
      if @channel_customer.save
        format.html { redirect_to @channel_customer, notice: 'Channel customer was successfully created.' }
        format.json { render :show, status: :created, location: @channel_customer }
      else
        format.html { render :new }
        format.json { render json: @channel_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channel_customers/1
  # PATCH/PUT /channel_customers/1.json
  def update
    respond_to do |format|
      if @channel_customer.update(channel_customer_params)
        format.html { redirect_to @channel_customer, notice: 'Channel customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel_customer }
      else
        format.html { render :edit }
        format.json { render json: @channel_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_customers/1
  # DELETE /channel_customers/1.json
  def destroy
    @channel_customer.destroy
    respond_to do |format|
      format.html { redirect_to channel_customers_url, notice: 'Channel customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_channel_customer
    @channel_customer = ChannelCustomer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def channel_customer_params
    params.require(:channel_customer).permit(:kode_channel_customer, :channel_id, :nama,
      :alamat, :dari_tanggal, :sampai_tanggal, :kota, :group,
      recipients_attributes: [:id, :sales_counter_id, :brand_id],
      merchants_attributes: [:id, :nama, :no_merchant, :tenor, :mid, :_destroy],
      supervisor_exhibition_attributes: [:id, :nama, :email, :nik, :handphone, :handphone1, :_destroy],
      sales_promotions_attributes: [:id, :nama, :email, :nik, :handphone, :handphone1, :_destroy],
      supervisor_exhibitions_attributes: [:id, :nama, :email, :nik, :handphone, :handphone1, :_destroy])
  end
end
