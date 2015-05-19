class PageController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:home, :download_manual_book]

  def admin_master_landing_page

    respond_to do |format|
      format.html
    end
  end

  def home
    respond_to do |format|
      format.html
    end
  end

  def download_manual_book
    respond_to do |format|
      format.pdf do
        send_file(
          "#{Rails.root}/public/pos_user_manual.pdf",
          filename: "pos_user_manual.pdf",
          type: "application/pdf"
        )
      end
    end
  end
end
