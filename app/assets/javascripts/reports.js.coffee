jQuery ->
  $(':checkbox').each ->
    this.checked = false

  $('#sales_rekap').DataTable({
    "bAutoWidth": true,
    "bProcessing": false,
    "sScrollXInner": "7000px",
    "bFilter": false,
    "sScrollX": "100%",
    "bScrollCollapse": true,
    "iDisplayLength": 10
  })

  $('#sales_rekap_so').DataTable({
    "bAutoWidth": true,
    "bProcessing": false,
    "sScrollXInner": "7000px",
    "bFilter": false,
    "sScrollX": "110%",
    "bScrollCollapse": true,
    "iDisplayLength": 10
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
