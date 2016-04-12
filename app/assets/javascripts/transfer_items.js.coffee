# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


jQuery ->

  $('#transfer_item_tsh').autocomplete
    source: $('#transfer_item_tsh').data('autocomplete-source')

  $('#transfer_item_nbrg').autocomplete
    source: $('#transfer_item_nbrg').data('autocomplete-source')
    select: (event, ui) ->
      $.ajax
        url: '/transfer_items/get_kode_from_nama',
        data: {'nama': ui.item.value, 'element_id': $(this).attr("id")},
        datatype: 'script'

  $('#transfer_item_sn').autocomplete
    source: $('#transfer_item_sn').data('autocomplete-source')
    select: (event, ui) ->
      $.ajax
        url: '/transfer_items/get_nama_from_serial',
        data: {'serial': ui.item.value, 'element_id': $(this).attr("id")},
        datatype: 'script',
        success: () ->
          document.getElementById('transfer_item_nbrg').readOnly = true