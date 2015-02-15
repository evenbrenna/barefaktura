
# Client: Autofill invoice client from dropdown
jQuery ->
  $("#invoice_client_id").change ->
    $.get "/clients/" + $(this).val() + "/get_json", (data, status, xhr) ->
      clientObject = JSON.parse(data)
      $("#invoice_client_name").val(clientObject.name)
      $("#invoice_client_email").val(clientObject.email)
      $("#invoice_client_org_nr").val(clientObject.org_nr)
      $("#invoice_client_ref").val(clientObject.ref)
      $("#invoice_client_address").val(clientObject.address)
      $("#invoice_delivery_address").val(clientObject.delivery_address)

# Product: Autofill invoice_item from dropdown
jQuery ->
  $("#products").change ->
    $.get "/products/" + $(this).val() + "/get_json", (data, status, xhr) ->
      productObject = JSON.parse(data)
      $("#invoice_invoice_items_attributes_0_description").val(
        productObject.description)
      $("#invoice_invoice_items_attributes_0_unit").val(productObject.unit)
      $("#invoice_invoice_items_attributes_0_unit_price").val(
        productObject.price)
      $("#invoice_invoice_items_attributes_0_vat").val(productObject.vat)
