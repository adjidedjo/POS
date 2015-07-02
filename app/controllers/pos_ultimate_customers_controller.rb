class PosUltimateCustomersController < ApplicationController
  before_action :set_pos_ultimate_customer, only: [:show, :edit, :update, :destroy]
  before_action :set_controller, only: [:show, :index]

  def get_customer_info
    @cust_info = PosUltimateCustomer.find_by_no_telepon(params[:no_telepon])

    respond_to do |format|
      format.js
    end
  end

  # GET /pos_ultimate_customers
  # GET /pos_ultimate_customers.json
  def index
    @pos_ultimate_customers = PosUltimateCustomer.order(:no_telepon).where("no_telepon like ?", "%#{params[:term]}%")

    respond_to do |format|
      format.html
      format.json {render json: @pos_ultimate_customers.map(&:no_telepon)}
    end
  end

  # GET /pos_ultimate_customers/1
  # GET /pos_ultimate_customers/1.json
  def show
  end

  # GET /pos_ultimate_customers/new
  def new
    @pos_ultimate_customer = PosUltimateCustomer.new
  end

  # GET /pos_ultimate_customers/1/edit
  def edit
  end

  # POST /pos_ultimate_customers
  # POST /pos_ultimate_customers.json
  def create
    @pos_ultimate_customer = PosUltimateCustomer.new(pos_ultimate_customer_params)

    respond_to do |format|
      if @pos_ultimate_customer.save
        format.html { redirect_to @pos_ultimate_customer, notice: 'Pos ultimate customer was successfully created.' }
        format.json { render :show, status: :created, location: @pos_ultimate_customer }
      else
        format.html { render :new }
        format.json { render json: @pos_ultimate_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pos_ultimate_customers/1
  # PATCH/PUT /pos_ultimate_customers/1.json
  def update
    respond_to do |format|
      if @pos_ultimate_customer.update(pos_ultimate_customer_params)
        format.html { redirect_to @pos_ultimate_customer, notice: 'Pos ultimate customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @pos_ultimate_customer }
      else
        format.html { render :edit }
        format.json { render json: @pos_ultimate_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pos_ultimate_customers/1
  # DELETE /pos_ultimate_customers/1.json
  def destroy
    @pos_ultimate_customer.destroy
    respond_to do |format|
      format.html { redirect_to pos_ultimate_customers_url, notice: 'Pos ultimate customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_controller
      @controller = current_user.role == 'controller'
    end

  # Use callbacks to share common setup or constraints between actions.
  def set_pos_ultimate_customer
    @pos_ultimate_customer = PosUltimateCustomer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pos_ultimate_customer_params
    params.require(:pos_ultimate_customer).permit(:nama, :alamat, :email, :no_telepon,
      :handphone, :handphone1, :kode_customer, :kota)
  end
end
