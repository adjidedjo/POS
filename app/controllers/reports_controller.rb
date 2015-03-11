class ReportsController < ApplicationController
  def index
    @sales = SaleItem.all if current_user.admin?
    @sales = User.find(current_user.id).sale_items unless current_user.admin?
  end

  def sales_counter
    @sales = []
    Store.where(branch_id: current_user.branch_id).each do |store|
      store.sales.each do |sale|
        SaleItem.where("sale_id = ? and created_at <= ? and exported =  ?", sale.id, Date.tomorrow, false).each do |sale_items|
          @sales << sale_items
        end
      end
    end
    get_branch = Branch.find(current_user.branch_id).alias+Date.today.strftime('%Y%m%d').to_s

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
    params[:sale_items_ids].each do |sale_item_ids|
      SaleItem.where("id = ?", sale_item_ids.to_i).each do |sale_item|
        @sales << sale_item
        sale_item.update_attributes(exported_at: Time.now, exported_by: current_user.id, exported: true)
      end
    end
    get_branch = Branch.find(current_user.branch_id).alias+Time.now.strftime("%d%m%Y%H%M%S")

    respond_to do |format|
      format.html
      format.xml do
        stream = render_to_string(:template=>"reports/sales_counter.xml.builder" )
        send_data(stream, :type=>"text/xml",:filename => "#{get_branch}.xml")
      end
    end
  end
end
