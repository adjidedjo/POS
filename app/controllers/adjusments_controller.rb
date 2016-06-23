class AdjusmentsController < ApplicationController
  before_action :set_adjusment, only: [:show, :edit, :update, :destroy]

  def find_showroom
    @channel = ChannelCustomer.order(:nama).where("nama like ?", "%#{params[:term]}%")

    respond_to do |format|
      format.html
      format.json {render json: @channel.map(&:nama)}
    end
  end

  # GET /adjusments GET /adjusments.json
  def index
    @channel_customer = []
    channel = current_user.branch.present? ? current_user.branch.sales_counters : []
    if channel.present?
      current_user.branch.sales_counters.each do |sc|
        sc.recipients.group(:channel_customer_id, :sales_counter_id).each do |scr|
          @channel_customer << scr.channel_customer.id
        end
      end
    else
      ChannelCustomer.all.each do |cc|
        @channel_customer << cc.id
      end
    end
    @adjusments = Adjusment.where("created_at >= ? and channel_customer_id in (?)", 2.month.ago, @channel_customer)
  end

  # GET /adjusments/1 GET /adjusments/1.json
  def show
  end

  # GET /adjusments/new
  def new
    @adjusment = Adjusment.new
  end

  # GET /adjusments/1/edit
  def edit
  end

  # POST /adjusments POST /adjusments.json
  def create
    @adjusment = Adjusment.new(adjusment_params)

    respond_to do |format|
      if @adjusment.save
        format.html { redirect_to new_adjusment_path, notice: 'Adjusment was successfully created.' }
        format.json { render :show, status: :created, location: @adjusment }
      else
        format.html { render :new }
        format.json { render json: @adjusment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adjusments/1 PATCH/PUT /adjusments/1.json
  def update
    respond_to do |format|
      if @adjusment.update(adjusment_params)
        format.html { redirect_to @adjusment, notice: 'Adjusment was successfully updated.' }
        format.json { render :show, status: :ok, location: @adjusment }
      else
        format.html { render :edit }
        format.json { render json: @adjusment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adjusments/1 DELETE /adjusments/1.json
  def destroy
    @adjusment.destroy
    respond_to do |format|
      format.html { redirect_to adjusments_url, notice: 'Adjusment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_adjusment
    @adjusment = Adjusment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def adjusment_params
    params.require(:adjusment).permit(:channel_customer_id, :kode_barang, :jumlah, :alasan, :serial, :nama_channel, :no_sj)
  end
end
