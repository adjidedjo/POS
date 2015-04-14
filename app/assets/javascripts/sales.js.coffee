jQuery ->
  $(document).on "page:fetch", ->
    Turbolinks.enableTransitionCache();

  $(document).on "ready page:load", ->

    setCharAt = (str, index, chr) ->
      if index > str.length - 1
        return str
      str.substr(0, index) + chr + str.substr(index + 1)

    resize_items = () -> $('.resize_fields').on 'click', (event) ->
      kode_id =  $(this).closest('fieldset').find("input[class='kode_barang']").attr("id")
      nama_barang_id = kode_id.replace("kode_barang", "nama_barang")
      serial_id = kode_id.replace("kode_barang", "serial")
      document.getElementById(serial_id).value = ''
      document.getElementById(kode_id).readOnly = false
      document.getElementById(nama_barang_id).readOnly = false
      str_value = document.getElementById(kode_id).value
      t_value = setCharAt(str_value,11,'T')
      document.getElementById(kode_id).value = t_value
      event.preventDefault()

    $('#sale_no_telepon').autocomplete
      source: $('#sale_no_telepon').data('autocomplete-source'),
      select: (event, ui) ->
         $.ajax
           url: '/pos_ultimate_customers/get_customer_info',
           data: {'no_telepon': ui.item.value},
           datatype: 'script'
           response: (event, ui) ->
             if (ui.content.length == 0)
               $('#sale_email, #sale_no_telepon, #sale_handphone, #sale_handphone1, #sale_alamat, #sale_kota').each ->
               $(this).val('')

    serial_change = () -> $('.serial').on 'focus', () ->
      get_id = "sale_sale_items_attributes_0_serial"
      jumlah = get_id.replace("serial", "jumlah")
      kode_barang = get_id.replace("serial", "kode_barang")
      nama_barang = get_id.replace("serial", "nama_barang")
      $('#sale_sale_items_attributes_0_serial').autocomplete
        source: $('#sale_sale_items_attributes_0_serial').data('autocomplete-source'),
        select: (event, ui) ->
          $.ajax
            url: '/sales/get_kode_barang_from_serial',
            data: {'kode_barang': ui.item.value, 'element_id': $(this).attr("id")},
            datatype: 'script',
            success: () ->
              document.getElementById(kode_barang).readOnly = true
            error: () ->
              alert "Serial yang anda masukan tidak terdaftar"
              document.getElementById(jumlah).readOnly = false
              document.getElementById(kode_barang).value = ""
              document.getElementById(kode_barang).disabled = false
              document.getElementById(nama_barang).value = ""
              document.getElementById(kode_barang).value = ""
              document.getElementById(jumlah).value = ""

    get_first_tenor = () -> $('#sale_payment_with_credit_cards_attributes_0_no_merchant').on 'change', () ->
      get_id = "sale_payment_with_credit_cards_attributes_0_no_merchant"
      $.ajax
        url: '/sales/get_mid_from_merchant',
        data: {'merchant': $('#sale_payment_with_credit_cards_attributes_0_no_merchant').val()}

    get_second_tenor = () -> $('#sale_payment_with_credit_cards_attributes_1_no_merchant').on 'change', () ->
      get_id = "sale_payment_with_credit_cards_attributes_1_no_merchant"
      $.ajax
        url: '/sales/get_second_mid_from_merchant',
        data: {'merchant': $('#sale_payment_with_credit_cards_attributes_1_no_merchant').val()}

    $('#new_sale').bind 'submit', ->
      $(this).find(':input').removeAttr 'disabled'

    $('#new_sale').validate
      rules:
        "tipe_pembayaran[]":
          required: true
        "sale_sales_promotion_id":
          required: true
        "sale_pembayaran":
          required: (element) ->
            $('#tipe_pembayaran_').val('Tunai').is(':checked')

    $('#check_all').click ->
      if @checked
        # Iterate each checkbox
        $(':checkbox').each ->
          @checked = true
          return
      else
        $(':checkbox').each ->
          @checked = false
          return
      return

    stores = $('#sale_store_id').html()
    $('#sale_channel_id').change ->
      channel = $('#sale_channel_id :selected').text()
      options = $(stores).filter("optgroup[label='#{channel}']").html()
      if options
        $('#sale_store_id').html(options)
        $('#sale_store_id').parent().show()
      else
        $('#sale_store_id').empty()
        $('#sale_store_id').parent().hide()

    addCommas = (str) ->
      parts = (str + '').split('.')
      main = parts[0]
      len = main.length
      output = ''
      i = len - 1
      while i >= 0
        output = main.charAt(i) + output
        if (len - i) % 3 == 0 and i > 0
          output = ',' + output
        --i
      # put decimal part back
      if parts.length > 1
        output += '.' + parts[1]
      output

    $('.input_value').on 'keyup', () ->
      netto = document.getElementById('sale_netto').value
      document.getElementById('span_netto').innerHTML = addCommas(netto)

      pembayaran = document.getElementById('sale_pembayaran').value
      document.getElementById('span_bayar').innerHTML = addCommas(pembayaran)

      debit = document.getElementById('sale_payment_with_debit_card_attributes_jumlah').value
      document.getElementById('span_debit').innerHTML = addCommas(debit)

      credit = document.getElementById('sale_payment_with_credit_cards_attributes_0_jumlah').value

      credit1 = document.getElementById('sale_payment_with_credit_cards_attributes_1_jumlah').value
      total_credit = Math.floor(credit) + Math.floor(credit1)
      document.getElementById('span_credit').innerHTML = addCommas(total_credit)

      transfer = document.getElementById('sale_jumlah_transfer').value
      document.getElementById('span_transfer').innerHTML = addCommas(transfer)

      total_payment = Math.floor(total_credit)+Math.floor(debit)+Math.floor(pembayaran)+Math.floor(transfer)
      voucher = document.getElementById('sale_voucher').value
      document.getElementById('span_voucher').innerHTML = addCommas(voucher)
      c = document.getElementById('sale_sisa').value = netto - voucher - total_payment
      document.getElementById('span_sisa').innerHTML = addCommas(c)

      elite = document.getElementById('sale_netto_elite').value
      document.getElementById('span_netto_elite').innerHTML = addCommas(elite)
      lady = document.getElementById('sale_netto_lady').value
      document.getElementById('span_netto_lady').innerHTML = addCommas(lady)

    open_modal = (id) ->
      $('#MyModal').on 'shown.bs.modal', (e) ->
        $(e.currentTarget).find('.id_form').val(id)

    date_picker = () -> $('.tanggal_kirim').datepicker({
      dateFormat: 'yy-mm-dd',
      minDate: new Date()
    })

    date_picker()
    serial_change()
    get_second_tenor()
    get_first_tenor()
    resize_items()

    $('#index_of_sales').DataTable()
    $('#sale_item').DataTable({
      bPaginate: false,
      bFilter: false,
      bInfo: false,
      bDestroy: true
    })
    $('#index_of_reports').DataTable({
      bInfo: false,
      responsive: true,
      bDestroy: true
    })
    $('#of_sales').DataTable({
      bPaginate: false,
      bFilter: false,
      bInfo: false,
      bAutoWidth: false,
      "aoColumnDefs": [
        { 'bSortable': false, 'aTargets': [ -1,0,1,2,3,4,5,6,7 ] }
      ],
      bDestroy: true
    })

    $('form').on 'click', '.add_fields', (event) ->
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      get_id = "sale_sale_items_attributes_"+time+"_serial"
      jumlah = get_id.replace("serial", "jumlah")
      kode_barang = get_id.replace("serial", "kode_barang")
      nama_barang = get_id.replace("serial", "nama_barang")
      resize_items()
      event.preventDefault()
      open_modal(get_id)
      date_picker()
      serial_doc = document.getElementById(get_id)
      $("#sale_sale_items_attributes_"+time+"_serial").autocomplete
        source: $("#sale_sale_items_attributes_"+time+"_serial").data('autocomplete-source'),
        select: (event, ui) ->
          $.ajax
            url: '/sales/get_kode_barang_from_serial',
            data: {'kode_barang': ui.item.value, 'element_id': $(this).attr("id")},
            datatype: 'script',
            success: () ->
              document.getElementById(kode_barang).readOnly = true
              document.getElementById(nama_barang).readOnly = true
            error: () ->
              alert "Serial yang anda masukan tidak terdaftar"
              document.getElementById(jumlah).readOnly = false
              document.getElementById(kode_barang).readOnly = false
              document.getElementById(nama_barang).value = ""
              document.getElementById(kode_barang).value = ""
              document.getElementById(jumlah).value = ""

    $('form').on 'click', '.remove_fields', (event) ->
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      event.preventDefault()