class AcquittancesController < ApplicationController
  before_action :set_acquittance, only: [:show, :edit, :update, :destroy]

  def export_xml
    @acquittance = Acquittance.find(params[:acqs_ids])
    @user = current_user.channel_customer
    get_branch = "P"+Time.now.strftime("%d%m%Y%H%M%S")

    respond_to do |format|
      format.xml do
        stream = render_to_string(:template=>"acquittances/rekap_pelunasan.xml.builder" )
        send_data(stream, :type=>"text/xml",:filename => "#{get_branch}.xml")
      end
    end
  end

  def rekap_pelunasan
    @sales = Acquittance.where(channel_customer_id: current_user.channel_customer.id, exported: false)


    respond_to do |format|
      format.html
      format.xls
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

  def get_sale_info
    @sale_info = Sale.find_by_no_so(params[:so])

    respond_to do |format|
      format.js
    end
  end

  def search_sales
    @all_sales = Sale.order(:no_so).where("sisa > 0 and all_items_exported = true and no_so like ?", "%#{params[:term]}%")

    respond_to do |format|
      format.html
      format.json {render json: @all_sales.map(&:no_so)}
    end
  end

  # GET /acquittances GET /acquittances.json
  def index
    @acquittances = Acquittance.all
  end

  # GET /acquittances/1 GET /acquittances/1.json
  def show

    respond_to do |format|
      format.html
      format.pdf do
        pdf = AcqPdf.new(@acquittance)
        send_data pdf.render, filename: "#{@acquittance.no_reference}",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  # GET /acquittances/new
  def new
    @acquittance = Acquittance.new
    @acquittance.build_acquittance_with_debit_card
    2.times {@acquittance.acquittance_with_credit_cards.build}
    @merchant = current_user.channel_customer.merchants.group([:nama, :no_merchant])
    @tenor = []

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /acquittances/1/edit
  def edit
  end

  # POST /acquittances POST /acquittances.json
  def create
    @acquittance = Acquittance.new(acquittance_params)
    @acquittance.method_of_payment = params[:tipe_pembayaran].join(';')
    @merchant = current_user.channel_customer.merchants.group([:nama, :no_merchant])
    @tenor = []
    @acquittance.channel_customer_id = current_user.channel_customer.id

    respond_to do |format|
      if @acquittance.save
        format.html { redirect_to @acquittance, notice: 'Acquittance was successfully created.' }
        format.json { render :show, status: :created, location: @acquittance }
      else
        format.html { render :new }
        format.json { render json: @acquittance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acquittances/1 PATCH/PUT /acquittances/1.json
  def update
    respond_to do |format|
      if @acquittance.update(acquittance_params)
        format.html { redirect_to @acquittance, notice: 'Acquittance was successfully updated.' }
        format.json { render :show, status: :ok, location: @acquittance }
      else
        format.html { render :edit }
        format.json { render json: @acquittance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acquittances/1 DELETE /acquittances/1.json
  def destroy
    @acquittance.destroy
    respond_to do |format|
      format.html { redirect_to acquittances_url, notice: 'Acquittance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_acquittance
    @acquittance = Acquittance.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def acquittance_params
    params.require(:acquittance).permit(:id, :sale_id, :no_reference, :method_of_payment, :no_so,
      :cash_amount, :transfer_amount, :bank_account_id,
      acquittance_with_credit_cards_attributes: [:id, :no_merchant, :nama_kartu, :no_kartu_kredit, :atas_nama, :jumlah, :tenor, :mid],
      acquittance_with_debit_card_attributes: [:id, :nama_kartu, :no_kartu_debit, :atas_nama, :jumlah])
  end
end
