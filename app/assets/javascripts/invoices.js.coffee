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
    $(this).closest('tr').removeClass('danger')
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
      table = $(data).find('.table-responsive').html()
      $('.table-responsive').hide('drop').html(table).show(
        'drop', {direction: 'right'})