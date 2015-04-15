class ReportsController < ApplicationController

  def selisih_retur
    @retur = ExhibitionStockItem.where(channel_customer_id: current_user.channel_customer.id).group(:kode_barang, :no_sj)

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def selisih_intransit
    @intransit = ExhibitionStockItem.where(channel_customer_id: current_user.channel_customer.id).group(:kode_barang, :no_sj)

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def mutasi_stock
    @report_stock_in = StoreSalesAndStockHistory.where(channel_customer_id: current_user.channel_customer.id).where("qty_in > ?", 0)
    @report_stock_out = StoreSalesAndStockHistory.where(channel_customer_id: current_user.channel_customer.id, keterangan: "S").where("qty_out > ?", 0)
    @report_stock_return = StoreSalesAndStockHistory.where(channel_customer_id: current_user.channel_customer.id, keterangan: "B").where("qty_out > ?", 0)

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def rekap_so
    @sales = []
    Sale.where(channel_customer_id: current_user.channel_customer.id, cancel_order: false).each do |sale|
      SaleItem.where(sale_id: sale.id).each do |sale_item|
        @sales << sale_item
      end
    end

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def index
    @sales = SaleItem.all if current_user.admin?
    @sales = User.find(current_user.id).sale_items unless current_user.admin?
  end

  def sales_counter
    @sales = []
    brand_id = params[:brand_id]
    current_user.channel_customer.sales.where(cancel_order: false).each do |sale|
      SaleItem.where("sale_id = ? and created_at < ? and exported = ? and brand_id = ?", sale.id, Date.tomorrow, false, brand_id).each do |sale_items|
        @sales << sale_items
      end
    end

    respond_to do |format|
      format.html
    end
  end

  def export_xml
    @sales = []
    @user = current_user.channel_customer
    @chosen_sale_item = params[:sale_items_ids]
    @email = params[:email]
    @chosen_sale_item.each do |sale_item_ids|
      SaleItem.where("id = ?", sale_item_ids.to_i).each do |sale_item|
        @sales << sale_item
        sale_item.update_attributes(exported: true, exported_at: Time.now, exported_by: current_user.id)
      end
    end
    Sale.set_exported_items(@sales.group_by(&:sale_id).keys)
    get_branch = Time.now.strftime("%d%m%Y%H%M%S")

    respond_to do |format|
      format.xml do
        stream = render_to_string(:template=>"reports/sales_counter.xml.builder" )
        send_data(stream, :type=>"text/xml",:filename => "#{get_branch}.xml")
        render(:template=>"reports/sales_counter.html" )
      end
    end
  end
end
