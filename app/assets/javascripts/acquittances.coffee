jQuery ->
  $(document).on 'ready page:load', ->

    $('#new_acquittance').validate
      rules:
        "tipe_pembayaran[]":
          required: true
        "acquittance_no_so":
          required: true
        "acquittance_cash_amount":
          number: (element) ->
            $('#tipe_pembayaran_').val('Tunai').is(':checked')

    addCommas = (str) ->
      parts = (str + '').split('.')
      main = parts[0]
      len = main.length
      output = ''
      i = len - 1
      while i >= 0
        output = main.charAt(i) + output
        if (len - i) % 3 == 0 and i > 0
          output = ',' + output
        --i
      # put decimal part back
      if parts.length > 1
        output += '.' + parts[1]
      output

    $('.input_value').on 'keyup', () ->

      pembayaran = document.getElementById('acquittance_cash_amount').value
      document.getElementById('span_bayar_acq').innerHTML = addCommas(pembayaran)

      pembayaran_transfer = document.getElementById('acquittance_transfer_amount').value
      document.getElementById('span_transfer_acq').innerHTML = addCommas(pembayaran_transfer)

      debit = document.getElementById('acquittance_acquittance_with_debit_card_attributes_jumlah').value
      document.getElementById('span_debit_acq').innerHTML = addCommas(debit)

      credit = document.getElementById('acquittance_acquittance_with_credit_cards_attributes_0_jumlah').value

      credit1 = document.getElementById('acquittance_acquittance_with_credit_cards_attributes_1_jumlah').value
      total_credit = Math.floor(credit) + Math.floor(credit1)
      document.getElementById('span_credit_acq').innerHTML = addCommas(total_credit)

      transfer = document.getElementById('sale_jumlah_transfer').value
      document.getElementById('span_transfer').innerHTML = addCommas(transfer)

      total_payment = Math.floor(total_credit)+Math.floor(debit)+Math.floor(pembayaran)+Math.floor(transfer)
      voucher = document.getElementById('sale_voucher').value
      document.getElementById('span_voucher').innerHTML = addCommas(voucher)
      c = document.getElementById('sale_sisa').value = netto - voucher - total_payment
      document.getElementById('span_sisa').innerHTML = addCommas(c)

      elite = document.getElementById('sale_netto_elite').value
      document.getElementById('span_netto_elite').innerHTML = addCommas(elite)
      lady = document.getElementById('sale_netto_lady').value
      document.getElementById('span_netto_lady').innerHTML = addCommas(lady)

    $('#acquittance_no_so').autocomplete
      source: $('#acquittance_no_so').data('autocomplete-sales')
      select: (event, ui) ->
        $.ajax
          url: '/acquittances/get_sale_info',
          data: {'so': ui.item.value},
          datatype: 'script'

    $('#acquittance_acquittance_with_credit_cards_attributes_0_no_merchant').on 'change', () ->
      get_id = "acquittance_acquittance_with_credit_cards_attributes_0_no_merchant"
      $.ajax
        url: '/acquittances/get_mid_from_merchant',
        data: {'merchant': $('#acquittance_acquittance_with_credit_cards_attributes_0_no_merchant').val()}

    $('#acquittance_acquittance_with_credit_cards_attributes_1_no_merchant').on 'change', () ->
      get_id = "acquittance_acquittance_with_credit_cards_attributes_1_no_merchant"
      $.ajax
        url: '/acquittances/get_second_mid_from_merchant',
        data: {'merchant': $('#acquittance_acquittance_with_credit_cards_attributes_1_no_merchant').val()}