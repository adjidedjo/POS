jQuery ->

  $('input.tanggal').datepicker({
    dateFormat: 'yy-mm-dd',
    minDate: new Date()
  })