jQuery ->

  $(document).on "ready page:load",  ->
    $('#total_cash_acc').DataTable({
      bInfo: false
    })

    $('#total_transfer_acc').DataTable({
      bInfo: false
    })

    $('#total_debit_acc').DataTable({
      bInfo: false
    })

    $('#total_credit_acc').DataTable({
      bInfo: false
    })
