jQuery ->

  $(document).on "ready page:load",  ->
    $('#total_cash_acc').DataTable({
      bInfo: false,
      "bDestroy": true
    })

    $('#total_transfer_acc').DataTable({
      bInfo: false,
      "bDestroy": true
    })

    $('#total_debit_acc').DataTable({
      bInfo: false,
      "bDestroy": true
    })

    $('#total_credit_acc').DataTable({
      bInfo: false,
      "bDestroy": true
    })
