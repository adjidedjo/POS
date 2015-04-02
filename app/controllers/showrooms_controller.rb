class ShowroomsController < ApplicationController
  before_action :set_showroom, only: [:show, :edit, :update, :destroy, :import_intransit, :proses_import_intransit]

  def proses_import_intransit
    tempfile = File.read(params[:stock_items].tempfile)
    showroom = current_user.showroom.id
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
        showroom_id: showroom,
        store_id: 0,
        jumlah: ((si.at_xpath("Serial").text.length <= 5) ? si.at_xpath("Serial").text : 1)
      }
      item_hash = {
        kode_barang: si.at_xpath("KodeBrg").text,
        nama: si.at_xpath("Nama").text
      }
      ExhibitionStockItem.where(kode_barang: si_hash[:kode_barang], serial: si_hash[:serial], no_sj: si_hash[:no_sj]).first_or_create(si_hash)
      Item.where(kode_barang: si_hash[:kode_barang]).first_or_create(item_hash)
    end

    respond_to do |format|
      format.html { redirect_to current_user.showroom, notice: 'Intransit sudah berhasil di upload.' }
      format.json { render :show, status: :created, location: @showroom }
    end
  end

  def import_intransit
  end

  # GET /showrooms
  # GET /showrooms.json
  def index
    @showrooms = Showroom.all
  end

  # GET /showrooms/1
  # GET /showrooms/1.json
  def show
  end

  # GET /showrooms/new
  def new
    @showroom = Showroom.new
    @showroom.merchants.build
  end

  # GET /showrooms/1/edit
  def edit
  end

  # POST /showrooms
  # POST /showrooms.json
  def create
    @showroom = Showroom.new(showroom_params)

    respond_to do |format|
      if @showroom.save
        format.html { redirect_to @showroom, notice: 'Showroom was successfully created.' }
        format.json { render :show, status: :created, location: @showroom }
      else
        format.html { render :new }
        format.json { render json: @showroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /showrooms/1
  # PATCH/PUT /showrooms/1.json
  def update
    respond_to do |format|
      if @showroom.update(showroom_params)
        format.html { redirect_to @showroom, notice: 'Showroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @showroom }
      else
        format.html { render :edit }
        format.json { render json: @showroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /showrooms/1
  # DELETE /showrooms/1.json
  def destroy
    @showroom.destroy
    respond_to do |format|
      format.html { redirect_to showrooms_url, notice: 'Showroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_showroom
    @showroom = Showroom.find(current_user.showroom)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def showroom_params
    params.require(:showroom).permit(:name, :branch_id, :city, :_destroy, merchants_attributes: [:id, :nama, :no_merchant, :tenor, :mid, :_destroy], sales_promotions_attributes: [:id, :nama, :email, :nik, :_destroy])
  end
end
