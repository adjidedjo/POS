class ReportsController < ApplicationController

  def rekap_stock
    @report_stock = StoreSalesAndStockHistory.all
  end

  def rekap_so
    @sales = []
    Sale.where(cancel_order: false).each do |sale|
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
    current_user.sales_promotion.store.sales.where(cancel_order: false).each do |sale|
      SaleItem.where("sale_id = ? and created_at < ? and exported = ? and brand_id = ?", sale.id, Date.tomorrow, false, brand_id).each do |sale_items|
        @sales << sale_items
      end
    end
    get_branch = Branch.find(current_user.sales_promotion.store.branch_id).alias+Date.today.strftime('%Y%m%d').to_s

    respond_to do |format|
      format.html
      format.xml do
        stream = render_to_string(:template=>"reports/sales_counter.xml.builder" )
        send_data(stream, :type=>"text/xml",:filename => "#{get_branch}.xml")
      end
    end
  end

  def export_xml
    @sales = []
    @user = current_user
    @email = params[:email]
    params[:sale_items_ids].each do |sale_item_ids|
      SaleItem.where("id = ?", sale_item_ids.to_i).each do |sale_item|
        @sales << sale_item
        sale_item.update_attributes(exported: true, exported_at: Time.now, exported_by: current_user.id)
      end
    end
    get_branch = Branch.find(current_user.sales_promotion.store.branch_id).alias+Time.now.strftime("%d%m%Y%H%M%S")

    respond_to do |format|
      format.html
      format.xml do
        stream = render_to_string(:template=>"reports/sales_counter.xml.builder" )
        send_data(stream, :type=>"text/xml",:filename => "#{get_branch}.xml")
      end
    end
  end
end
