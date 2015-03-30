class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores GET /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1 GET /stores/1.json
  def show
    @supervisor = @store.users.where(role: "supervisor")
  end

  # GET /stores/new
  def new
    @store = Store.new
    @store.build_supervisor_exhibition
    @store.merchants.build
    @store.sales_promotions.build
  end

  # GET /stores/1/edit
  def edit
    if @store.supervisor_exhibition.nil?
      @store.build_supervisor_exhibition
    end
  end

  # POST /stores POST /stores.json
  def create
    tempfile = File.read(store_params["stock_items"].tempfile)
    doc = Nokogiri::XML(tempfile)
    pameran = doc.xpath("data/pameran")
    pameran_hash = {
      channel_id: 5,
      nama: pameran.at_xpath("NamaPameran").text,
      kode_customer: pameran.at_xpath("KodePameran").text,
      jenis_pameran: pameran.at_xpath("JenisPameran").text,
      from_period: pameran.at_xpath("PeriodeAwal").text.to_date,
      to_period: pameran.at_xpath("PeriodeAkhir").text.to_date,
      keterangan: pameran.at_xpath("KeteranganPameran").text
    }
    @store = Store.where(kode_customer: pameran_hash[:kode_customer]).first_or_create(pameran_hash)
    supervisor_hash = {
      nama: pameran.at_xpath("Supervisor").text.capitalize,
      email: pameran.at_xpath("Supervisor").text.gsub(/ /, '')+"@ras.co.id",
      password: pameran.at_xpath("Supervisor").text[0,3].downcase+"*54321",
      role: "supervisor",
      store_id: @store.id
    }
    User.where(nama: supervisor_hash[:nama], store_id: @store.id).first_or_create(supervisor_hash)

    respond_to do |format|
      if @store.save
        create_stock_item_exhibition(store_params["stock_items"], @store.id)
        format.html { redirect_to root_path, notice: 'Store was successfully created.' } if current_user.role == 'sales_promotion'
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1 DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_store
    @store = Store.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def store_params
    params.require(:store).permit(:channel_id, :nama, :kota, :from_period, :to_period, :branch_id, :stock_items, :jenis_pameran, :keterangan, merchants_attributes: [:id, :nama, :no_merchant, :tenor, :mid, :_destroy], supervisor_exhibition_attributes: [:id, :nama, :email, :nik, :_destroy], sales_promotions_attributes: [:id, :nama, :email, :nik, :_destroy])
  end

  def create_stock_item_exhibition(file, store_id)
    tempfile = File.read(file.tempfile)
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
        store_id: store_id,
        jumlah: ((si.at_xpath("Serial").text.length <= 5) ? si.at_xpath("Serial").text : 1)
      }
      item_hash = {
        kode_barang: si.at_xpath("KodeBrg").text,
        nama: si.at_xpath("Nama").text
      }
      ExhibitionStockItem.where(kode_barang: si_hash[:kode_barang], serial: si_hash[:serial], no_sj: si_hash[:no_sj]).first_or_create(si_hash)
      Item.where(kode_barang: si_hash[:kode_barang]).first_or_create(item_hash)
    end
  end
end