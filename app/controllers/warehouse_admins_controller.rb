class WarehouseAdminsController < ApplicationController
  before_action :set_warehouse_admin, only: [:show, :edit, :update, :destroy]
  before_action :set_controller, only: [:show, :index]
  before_action :branches, only: [:new, :edit]

  # GET /warehouse_admins GET /warehouse_admins.json
  def index
    @warehouse_admins = WarehouseAdmin.all
  end

  # GET /warehouse_admins/1 GET /warehouse_admins/1.json
  def show
  end

  # GET /warehouse_admins/new
  def new
    @warehouse_admin = WarehouseAdmin.new
  end

  # GET /warehouse_admins/1/edit
  def edit
  end

  # POST /warehouse_admins POST /warehouse_admins.json
  def create
    @warehouse_admin = WarehouseAdmin.new(warehouse_admin_params)

    respond_to do |format|
      if @warehouse_admin.save
        format.html { redirect_to @warehouse_admin, notice: 'Warehouse admin was successfully created.' }
        format.json { render :show, status: :created, location: @warehouse_admin }
      else
        format.html { render :new }
        format.json { render json: @warehouse_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /warehouse_admins/1 PATCH/PUT /warehouse_admins/1.json
  def update
    respond_to do |format|
      if @warehouse_admin.update(warehouse_admin_params)
        format.html { redirect_to @warehouse_admin, notice: 'Warehouse admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @warehouse_admin }
      else
        format.html { render :edit }
        format.json { render json: @warehouse_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /warehouse_admins/1 DELETE /warehouse_admins/1.json
  def destroy
    @warehouse_admin.destroy
    respond_to do |format|
      format.html { redirect_to warehouse_admins_url, notice: 'Warehouse admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_warehouse_admin
    @warehouse_admin = WarehouseAdmin.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def warehouse_admin_params
    params.require(:warehouse_admin).permit(:nik, :nama, :email, :branch_id)
  end

  def set_controller
    @controller = current_user.role == 'controller'
  end

  def branches
    @branches = Branch.all
  end
end
