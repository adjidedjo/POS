jQuery ->

  $(document).on 'ready page:load', ->

    $('#channel_customer_group').autocomplete
        source: $('#channel_customer_group').data('autocomplete-channel')

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
        "channel_customer_nama":
          required: true
        "channel_customer_alamat":
          required: true
        "channel_customer_kota":
          required: true