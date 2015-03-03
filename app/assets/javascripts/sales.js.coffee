jQuery ->

  $('#index_of_sales').DataTable()

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

  date_picker = () -> $('input.tanggal').datepicker({
    dateFormat: 'yy-mm-dd',
    minDate: new Date()
  })

  add_item_to_table()
  open_modal()
  date_picker()
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    open_modal()
    date_picker()