# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $(document).on 'ready page:load', ->
    $('#index_of_sales_reports').DataTable({
      iDisplayLength: 100
    })

    $('#total_re').DataTable({
      bInfo: false,
      responsive: true,
      bPaginate: false,
      bFilter: false,
      bDestroy: true,
      'fnFooterCallback': (nRow, aaData) ->
        iTotalTarget = 0
        iTotalSales = 0
        i = 0
        while i < aaData.length
          iTotalTarget += parseCurrency(aaData[i][1]) * 1
          i++

        nCells = nRow.getElementsByTagName('td')
        nCells[1].innerHTML += addCommas(parseInt(iTotalTarget))
        return

    })

    $('#total_cs').DataTable({
      bInfo: false,
      responsive: true,
      bPaginate: false,
      bFilter: false,
      bDestroy: true,
      'fnFooterCallback': (nRow, aaData) ->
        iTotalTarget = 0
        iTotalSales = 0
        i = 0
        while i < aaData.length
          iTotalTarget += parseCurrency(aaData[i][1]) * 1
          i++

        nCells = nRow.getElementsByTagName('td')
        nCells[1].innerHTML += addCommas(parseInt(iTotalTarget))
        return

    })

    $('#total_pc').DataTable({
      bInfo: false,
      responsive: true,
      bPaginate: false,
      bFilter: false,
      bDestroy: true,
      'fnFooterCallback': (nRow, aaData) ->
        iTotalTarget = 0
        iTotalSales = 0
        i = 0
        while i < aaData.length
          iTotalTarget += parseCurrency(aaData[i][1]) * 1
          i++

        nCells = nRow.getElementsByTagName('td')
        nCells[1].innerHTML += addCommas(parseInt(iTotalTarget))
        return

    })

    $('#top_10_items').DataTable({
      bInfo: false,
      responsive: true,
      bPaginate: false,
      bFilter: false,
      bSort: false,
      bDestroy: true
    })

    $('#date').datepicker({
      dateFormat: 'yy-mm-dd',
      maxDate: '0'
    })

    $('#search_sale_sampai_tanggal').datepicker({
      dateFormat: 'yy-mm-dd',
      maxDate: '0'
    })

    $('#search_sale_dari_tanggal').datepicker({
      dateFormat: 'yy-mm-dd',
      maxDate: '0'
    })

  parseCurrency = (num) ->
    a = num.replace /\Rp./g, ''
    parseFloat a.replace(/\./g, '')

  addCommas = (nStr) ->
    nStr += ''
    x = nStr.split('.')
    x1 = x[0]
    x2 = if x.length > 1 then '.' + x[1] else ''
    rgx = /(\d+)(\d{3})/
    while rgx.test(x1)
      x1 = x1.replace(rgx, '$1' + '.' + '$2')
    x1 + x2
