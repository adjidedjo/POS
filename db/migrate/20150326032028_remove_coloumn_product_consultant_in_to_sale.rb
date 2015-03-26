class RemoveColoumnProductConsultantInToSale < ActiveRecord::Migration
  def change
    remove_column :sales, :product_consultant
  end
end
