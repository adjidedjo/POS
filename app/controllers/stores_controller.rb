class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores GET /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1 GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
    @store.merchants.build
    @store.build_supervisor_exhibition
    @store.sales_promotions.build
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores POST /stores.json
  def create
    @store = Store.new(store_params)
    create_stock_item_exhibition(store_params["stock_items"])

    respond_to do |format|
      if @store.save
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
    params.require(:store).permit(:channel_id, :nama, :kota, :from_period, :to_period, :branch_id, :stock_items, merchants_attributes: [:id, :nama, :no_merchant, :_destroy], supervisor_exhibition_attributes: [:id, :nama, :email, :nik], sales_promotions_attributes: [:id, :nama, :email, :nik])
  end

  def create_stock_item_exhibition(file)
    tempfile = File.read(file.tempfile)
    doc = Nokogiri::XML(tempfile)
    item = doc.xpath("data/pbjshow")
    item.each do |si|
      si_hash = {kode_barang: si.at_xpath("kodebrg").text}
      si_record = StockItemExhibition.create(si_hash)
      si_record.save
    end
  end
end