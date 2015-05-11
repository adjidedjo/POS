# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $(document).on "ready page:load", ->

    $('#table_receipt').DataTable({
      bInfo: false,
      responsive: true,
      bPaginate: false,
      bDestroy: true
    })

    $('#table_receipt').on 'change', 'td', (event) ->
      get_id = event.target.id
      kode_barang = document.getElementById(get_id.replace("jumlah", "kode_barang")).value
      no_sj = document.getElementById(get_id.replace("jumlah", "no_sj")).value
      cc = document.getElementById(get_id.replace("jumlah", "channel_customer_id")).value
      $.ajax
        url: '/item_receipts/check_item_value',
        data: {'val': event.target.value, 'kodebrg': kode_barang, 'nosj': no_sj, 'cc': cc, 'element_id': get_id},
        datatype: 'script'
        success: () ->
          document.getElementById(get_id).style.backgroundColor = "#00FF00";
        error: () ->
          document.getElementById(get_id).style.backgroundColor = "#FE0F0F";
