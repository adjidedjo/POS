class Accounting::VerifyingPaymentsController < ApplicationController
  before_action :index, only: [:verify]

  def index
    debit = []
    credit = []
    @sales = current_user.branch.sales_counters.first.recipients.first.channel_customer.sales.where(all_items_exported: true, verified: false)
    @sales.each do |sale|
      debit << sale.payment_with_debit_card.id
      credit << sale.payment_with_credit_cards.ids
    end
    credit_ids = credit.join(",").split("")
    @cd = PaymentWithDebitCard.where(id: debit).where.not(jumlah: 0)
    @cc = PaymentWithCreditCard.where(id: credit_ids)
    @bank = BankAccount.all
    @merchants = current_user.branch.sales_counters.first.recipients.first.channel_customer.merchants
  end

  def verify
    @sales.each do |a|
      a.update_attributes!(verified: true, verified_by: current_user.id, verified_at: Time.now)
    end
    redirect_to accounting_verifying_payments_path, notice: "Berhasil di verifikasi"
  end
end
