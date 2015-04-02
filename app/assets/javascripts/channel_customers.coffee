jQuery ->

  $('#show_sales_customer').DataTable({
    bPaginate: false,
    bFilter: false,
    bInfo: false
  })

  $('input.tanggal').datepicker({
    dateFormat: 'yy-mm-dd',
    minDate: new Date()
  })

  $('#new_channel_customer').validate
    rules:
      "channel_customer_channel_id":
        required: true
      "channel_customer_nama":
        required: true
      "channel_customer_alamat":
        required: true
      "channel_customer_kota":
        required: true