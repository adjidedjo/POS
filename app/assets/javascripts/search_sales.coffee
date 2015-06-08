# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $(document).on 'ready page:load', ->
    $('#index_of_sales_reports').DataTable({
      iDisplayLength: 100
    })

    $('#total_acv').DataTable({
      bInfo: false,
      responsive: true,
      bPaginate: false,
      bFilter: false,
      bDestroy: true
    })

    $('#top_10_items').DataTable({
      bInfo: false,
      responsive: true,
      bPaginate: false,
      bFilter: false,
      bSort: false,
      bDestroy: true
    })
