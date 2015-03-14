jQuery ->
  $(':checkbox').each ->
    this.checked = false

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
