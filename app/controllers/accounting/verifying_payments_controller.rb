class Accounting::VerifyingPaymentsController < ApplicationController
  before_action :index, only: [:verify]
  before_action :get_channel_customer_id, only:[:show_channel_payment]

  def index
    @channel_customer = []
    channel = current_user.branch.sales_counters
    if channel.present?
      current_user.branch.sales_counters.group(:branch_id).each do |sc|
        sc.recipients.group(:channel_customer_id, :sales_counter_id).each do |scr|
          @channel_customer << scr.channel_customer
        end
      end
    end
  end

  def show_channel_payment
    debit = []
    credit = []
    sip = []
    get_sales_counter = current_user.branch.sales_counters
    if get_sales_counter.present?
      SaleItem.where(brand_id: get_sales_counter.first.recipients.first.brand_id).group(:sale_id).each do |si|
        sip << si.sale_id
      end
      @sales = @channel.sales.where(id: sip, cancel_order: 0)
      @sales.each do |sale|
        debit << sale.payment_with_debit_card.id
        sale.payment_with_credit_cards.each do |pwc|
          credit << pwc.id
        end
      end
      @cd = PaymentWithDebitCard.where(id: debit).where.not(jumlah: 0)
      @cc = PaymentWithCreditCard.where(id: credit)
      @bank = BankAccount.all
      @merchants = current_user.branch.sales_counters.first.recipients.first.channel_customer.merchants
    else
      redirect_to root_path, alert: "Belum ada penjualan di #{current_user.branch.cabang.capitalize}"
    end
  end

  def verify
    @sales.each do |a|
      a.update_attributes!(verified: true, verified_by: current_user.id, verified_at: Time.now)
    end
    redirect_to accounting_verifying_payments_path, notice: "Berhasil di verifikasi"
  end

  private

  def get_channel_customer_id
    @channel = ChannelCustomer.find(params[:cc_id])
  end
end
