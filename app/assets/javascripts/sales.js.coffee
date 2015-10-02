jQuery ->
  $(document).on "page:fetch", ->
    Turbolinks.pagesCached(0);

  $(document).on "ready page:load", ->

    $('#span_netto').autoNumeric('init', mDec: 0)
    $('#span_sisa').autoNumeric('init', mDec: 0)
    $('.input_value').on 'change', () ->
      $('#span_sisa').autoNumeric('set', $('#sale_sisa').val())

    $('#new_sale').submit ->
      $('.price_list').each ->
        document.getElementById(this.id).value = Number(document.getElementById(this.id).value.replace(/[^0-9\.]+/g,""))

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
              document.getElementById(jumlah).readOnly = true
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
        "sale_jumlah_transfer":
          required: true
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

    money = () ->
      netto = Number(document.getElementById('sale_netto').value.replace(/[^0-9\.]+/g,""))
      pembayaran = Number(document.getElementById('sale_pembayaran').value.replace(/[^0-9\.]+/g,""))
      voucher = Number(document.getElementById('sale_voucher').value.replace(/[^0-9\.]+/g,""))

      debit = Number(document.getElementById('sale_payment_with_debit_cards_attributes_0_jumlah').value.replace(/[^0-9\.]+/g,""))
      total_debit = Math.floor(debit)


      credit = Number(document.getElementById('sale_payment_with_credit_cards_attributes_0_jumlah').value.replace(/[^0-9\.]+/g,""))
      credit1 = Number(document.getElementById('sale_payment_with_credit_cards_attributes_1_jumlah').value.replace(/[^0-9\.]+/g,""))
      total_credit = Math.floor(credit) + Math.floor(credit1)

      transfer = Number(document.getElementById('sale_jumlah_transfer').value.replace(/[^0-9\.]+/g,""))

      total_payment = Math.floor(total_credit)+Math.floor(total_debit)+Math.floor(pembayaran)+Math.floor(transfer)
      document.getElementById('sale_sisa').value = netto - voucher - total_payment

    $('.input_value').on 'keyup', () ->
      money()

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

    netto_pl = (id) ->
      document.getElementById(id).addEventListener "keyup", () ->
        a = document.getElementById('sale_netto').value
        c = 0
        $('.price_list').each ->
          c += Number($(this).val().replace(/[^0-9\.]+/g,""))
        document.getElementById('sale_netto').value = c

    $('form').on 'click', '.add_fields', (event) ->
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      get_id = "sale_sale_items_attributes_"+time+"_serial"
      jumlah = get_id.replace("serial", "jumlah")
      kode_barang = get_id.replace("serial", "kode_barang")
      nama_barang = get_id.replace("serial", "nama_barang")
      price_list = get_id.replace("serial", "price_list")
      $('#'+price_list).autoNumeric("init",{
        mDec:0
      })
      $('#'+price_list).on 'change', () ->
        $('#span_netto').autoNumeric('set', $('#sale_netto').val())
        money()
      taken = get_id.replace("serial", "taken")
      bonus = get_id.replace("serial", "bonus")
      resize_items()
      event.preventDefault()
      open_modal(get_id)
      netto_pl(price_list)
      date_picker()
      serial_doc = document.getElementById(get_id)
      $('#'+jumlah).focus ->
        $('#'+taken).prop("checked", false);
      $('#'+bonus).on "change", () ->
        if (this.checked)
          document.getElementById(price_list).readOnly = true
        else
          document.getElementById(price_list).readOnly = false
          document.getElementById(bonus).checked = false
      $('#'+taken).click ->
        if $(this).is(':checked')
          $.ajax
            url: '/sales/stock_availability',
            data: {
              'kode_barang': $("#"+ kode_barang).val(),
              'element_id': $(this).attr("id"),
              'jumlah': $('#'+jumlah).val()}
            datatype: 'script'
            error: () ->
              alert "Silahkan Cari barang terlebih dahulu"
              document.getElementById(taken).checked = false
        if !$(this).is(':checked')
          document.getElementById(serial).readOnly = false
          document.getElementById(serial).value = ""
          document.getElementById(kode_barang).value = ""
          document.getElementById(nama_barang).value = ""
          document.getElementById(jumlah).value = ""
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
      $("#sale_sale_items_attributes_"+time+"_nama_barang").autocomplete
        source: $("#sale_sale_items_attributes_"+time+"_nama_barang").data('autocomplete-source'),
        select: (event, ui) ->
          $.ajax
            url: '/sales/get_kode_barang_from_nama',
            data: {'nama': ui.item.value, 'element_id': $(this).attr("id")},
            datatype: 'script',
            success: () ->
              document.getElementById(kode_barang).readOnly = true
              document.getElementById(price_list).focus()

    $('form').on 'click', '.remove_fields', (event) ->
      price_list = document.getElementById($(this).prev().attr('id').replace("_destroy", "price_list"))
      price_list.className = "price_list1"
      $(this).prev('input[type=hidden]').val('1')
      price_list.readOnly = false
      $(this).closest('fieldset').hide()
      netto = document.getElementById('sale_netto').value
      document.getElementById('sale_netto').value -= Number(price_list.value)
      event.preventDefault()