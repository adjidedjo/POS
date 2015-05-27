jQuery ->
  $(document).on "ready page:load", ->
    $('#channel_customer_stock').DataTable()

    $('#view_penjualan').DataTable({
      "bAutoWidth": true,
      "bProcessing": false,
      "sScrollXInner": "7000px",
      "bFilter": true,
      "sScrollX": "110%",
      "bScrollCollapse": true,
      "bPaginate": false,
      "bInfo": false,
      "bDestroy": true
    })