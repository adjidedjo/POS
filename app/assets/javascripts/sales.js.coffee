jQuery ->
  formatAmountNoDecimals = (number) ->
    rgx = /(\d+)(\d{3})/
    while rgx.test(number)
      number = number.replace(rgx, '$1' + '.' + '$2')
    number

  formatAmount = (number) ->
    # remove all the characters except the numeric values
    number = number.replace(/[^0-9]/g, '')
    # set the default value
    if number.length == 0
      number = '0.00'
    else if number.length == 1
      number = '0.0' + number
    else if number.length == 2
      number = '0.' + number
    else
      number = number.substring(0, number.length - 2) + '.' + number.substring(number.length - 2, number.length)
    # set the precision
    number = new Number(number)
    number = number.toFixed(2)
    # only works with the "."
    # change the splitter to ","
    number = number.replace(/\./g, ',')
    # format the amount
    x = number.split(',')
    x1 = x[0]
    x2 = if x.length > 1 then ',' + x[1] else ''
    formatAmountNoDecimals(x1) + x2

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

  $('#sale_netto').on 'keyup', () ->
    $(this).val formatAmount($(this).val())
    pembayaran = document.getElementById('sale_pembayaran').value
    c = document.getElementById('sale_sisa').value = $(this).val() - pembayaran

  $('#sale_pembayaran').on 'keyup', () ->
    netto = document.getElementById('sale_netto').value
    c = document.getElementById('sale_sisa').value = netto - $(this).val()

  open_modal = () -> $('.kode_barang').on 'click', () ->
    $('#kode_barang').val(($(this).attr("id")))
    $('#nama_barang').val(($(this).attr("id")).replace("kode", "nama"))
    $('#modal-content').modal('show')

  add_item_to_table = () -> $('.add_to_sales').on 'click', () ->
    document.getElementById($('#kode_barang').val()).value = $(this).data('kode')
    document.getElementById($('#nama_barang').val()).value = $(this).data('nama')
    $('#modal-content').modal('hide')

  date_picker = () -> $('.tanggal_kirim').datepicker({
    dateFormat: 'yy-mm-dd',
    minDate: new Date()
  })

  serial_change = () -> $('.serial').on 'change', () ->
    get_id = "sale_sale_items_attributes_0_serial"
    jumlah = get_id.replace("serial", "jumlah")
    kode_barang = get_id.replace("serial", "kode_barang")
    nama_barang = get_id.replace("serial", "nama_barang")
    $.ajax
      url: '/sales/get_kode_barang_from_serial',
      data: {'kode_barang': $('.serial').val(), 'element_id': $(this).attr("id")},
      datatype: 'script',
      error: () ->
          alert "Serial yang anda masukan tidak terdaftar"
          document.getElementById(jumlah).readOnly = false
          document.getElementById(kode_barang).readOnly = false
          document.getElementById(nama_barang).value = ""
          document.getElementById(kode_barang).value = ""
          document.getElementById(jumlah).value = ""

  add_item_to_table()
  open_modal()
  date_picker()
  serial_change()
  $('#index_of_sales').DataTable()
  $('#sale_items').DataTable({
    bPaginate: false,
    bFilter: false,
    bInfo: false
  })
  $('#of_sales').DataTable({
    bPaginate: false,
    bFilter: false,
    bInfo: false,
    bAutoWidth: false,
    "aoColumnDefs": [
      { 'bSortable': false, 'aTargets': [ -1,0,1,2,3,4,5,6,7 ] }
    ]
  })

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    get_id = "sale_sale_items_attributes_"+time+"_serial"
    jumlah = get_id.replace("serial", "jumlah")
    kode_barang = get_id.replace("serial", "kode_barang")
    nama_barang = get_id.replace("serial", "nama_barang")
    event.preventDefault()
    open_modal()
    date_picker()
    serial_doc = document.getElementById(get_id)
    serial_doc.addEventListener 'change', () ->
      $.ajax
        url: '/sales/get_kode_barang_from_serial',
        data: {'kode_barang': $(this).val(), 'element_id': $(this).attr("id")},
        datatype: 'script',
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