jQuery ->
  $(':checkbox').each ->
    this.checked = false

  $('#sales_rekap').DataTable({
    "bAutoWidth": true,
    "bProcessing": false,
    "sScrollXInner": "7000px",
    "bFilter": true,
    "sScrollX": "100%",
    "bScrollCollapse": true,
    "bPaginate": false,
    "bInfo": false
  })

  $('#sales_rekap_so').DataTable({
    "bAutoWidth": true,
    "bProcessing": false,
    "sScrollXInner": "7000px",
    "bFilter": true,
    "sScrollX": "110%",
    "bScrollCollapse": true,
    "bPaginate": false,
    "bInfo": false
  })

  $('#sales_rekap_stock').DataTable({
    "bAutoWidth": true,
    "bProcessing": false,
    "sScrollXInner": "1500px",
    "bFilter": true,
    "sScrollX": "110%",
    "bScrollCollapse": true,
    "bPaginate": false,
    "bInfo": false
  })

  $('#rekapsales').validate
    rules:
      "email":
        required: true,
        email: true
      "sale_items_ids[]":
        required: true
    messages:
        "email": "Silahkan isi email sales counter"
        "sale_items_ids[]": "Pilih item"
