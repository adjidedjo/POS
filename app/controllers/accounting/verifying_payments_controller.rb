class Accounting::VerifyingPaymentsController < ApplicationController
  before_action :index, only: [:verify]

  def index
    debit = []
    credit = []
    get_sales_counter = current_user.branch.sales_counters
    if get_sales_counter.present?
      @sales = get_sales_counter.first.recipients.first.channel_customer.sales.where(all_items_exported: true, verified: false)
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
end
