class Accounting::VerifyingPaymentsController < ApplicationController
  before_action :index, only: [:verify]
  before_action :get_channel_customer_id, only:[:show_channel_payment]
  before_action :set_controller, only: [:show, :index]

  def show_order
    @sale = Sale.find(params[:sale_id])
    @get_spg = SalesPromotion.find(@sale.sales_promotion_id)
    @tipe_pembayaran = @sale.tipe_pembayaran.split(";")
  end

  def verify_order
    order = Sale.find(params[:order_id])
    if order.update_attributes!(validated: true)
      redirect_to show_channel_payment_accounting_verifying_payments_path(cc_id: params[:cc_id]), notice: 'Order sukses terverifikasi.'
    else
      redirect_to show_channel_payment_accounting_verifying_payments_path(cc_id: params[:cc_id]), alert: 'Order belum terverifikasi.'
    end
  end

  def index
    @channel_customer = []
    channel = current_user.branch.present? ? current_user.branch.sales_counters : []
    if channel.present?
      current_user.branch.sales_counters.group(:branch_id).each do |sc|
        sc.recipients.group(:channel_customer_id, :sales_counter_id).each do |scr|
          @channel_customer << scr.channel_customer
        end
      end
    else
      ChannelCustomer.all.each do |cc|
        @channel_customer << cc
      end
    end
  end

  def show_channel_payment
    @channel_customer = ChannelCustomer.find(params[:cc_id])
    @sales = Sale.where(channel_customer_id: params[:cc_id], validated: false, cancel_order: false)
  end

  def verify
    @sales.each do |a|
      a.update_attributes!(verified: true, verified_by: current_user.id, verified_at: Time.now)
    end
    redirect_to accounting_verifying_payments_path, notice: "Berhasil di verifikasi"
  end

  private
  def set_controller
    @controller = current_user.role == 'controller'
  end

  def get_channel_customer_id
    @channel = ChannelCustomer.find(params[:cc_id])
  end
end
