jQuery ->

  $(document).on 'ready page:load', ->

    $('#index_bank_accounts').DataTable({
      "bAutoWidth": true,
      "bProcessing": false,
      "sScrollXInner": "100px",
      "bFilter": true,
      "sScrollX": "100%",
      "bScrollCollapse": true,
      "bPaginate": false,
      "bInfo": false,
      "bDestroy": true
    })
