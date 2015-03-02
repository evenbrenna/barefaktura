# When marking invoice as paid, toggle class unpaid on
# glyphicon (<i>) and replace html in summary div with
# updated info
jQuery ->
  $('#invoice-table').on 'click', "[id$=paid-button]", (event) ->
    $.get $(this).attr("href"), (data, status, xhr) ->
      summary = $(data).find('#summary').html()
      $('#summary').html(summary)
    button = $(this).closest('a').find('i')
    button.hide().toggleClass('unpaid').fadeIn(800)
    if $(this).closest('tr').hasClass('overdue')
      $(this).closest('tr').toggleClass('danger')
    event.preventDefault()
  $(this).off

# Toggle between all, unpaid and overdue invoices
# in partial invoices/invoice_list
jQuery ->
  @invoices =
  invoiceList: (filter) ->
    $("[id$=selectbtn]").switchClass('btn-primary', 'btn-default', 0)
    $('#' + filter + '-selectbtn').switchClass(
      'btn-default', 'btn-primary', 0)
    $.get '?filter=' + filter, (data, status, xhr) ->
      table = $(data).find('#invoice-table').html()
      $('#invoice-table').hide().html(table).fadeIn(400)

jQuery ->
  $('#invoice-table').on 'click', ' li a', (event) ->
    event.preventDefault()
    $.get $(this).attr("href"), (data, status, xhr) ->
      table = $(data).find('#invoice-table').html()
      $('#invoice-table').html(table)
    $(this).off

# Loading spinner while loading ajax (all ajax requests)
# jQuery ->
#   $(document).on
#     ajaxStart: ->
#       $('body').addClass 'loading'
#       return
#     ajaxStop: ->
#       $('body').removeClass 'loading'
#       return

# Loading spinner while generating PDF on email send
jQuery ->
  $('#modal-invoice-email-window').on 'click', '.send-pdf-email', ->
    $('#modal-invoice-email-window').hide()
    $('body').addClass('loading')

# Loading modal while generating PDF for download
# Controller will redirect to pdf so no need to remove class
jQuery ->
  $('body').on 'click', '.pdf-link', ->
    $('body').addClass('loading')