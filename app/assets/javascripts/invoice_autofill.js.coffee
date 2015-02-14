
# Autofill client from select
jQuery ->
  $("#invoice_client_id").change ->
    $.get "/clients/" + $(this).val() + "/get_json", (data, status, xhr) ->
      dataobj = JSON.parse(data)
      $("#invoice_client_name").val(dataobj.name)
      $("#invoice_client_email").val(dataobj.email)
      $("#invoice_client_org_nr").val(dataobj.org_nr)
      $("#invoice_client_ref").val(dataobj.ref)
      $("#invoice_client_address").val(dataobj.address)
      $("#invoice_delivery_address").val(dataobj.delivery_address)

# Autofill invoice_item from product select
jQuery ->
  $("#products").change ->
    $.get "/products/" + $(this).val() + "/get_json", (data, status, xhr) ->
      productDataObj = JSON.parse(data)
      $("#invoice_invoice_items_attributes_0_description").val(
        productDataObj.description)
      $("#invoice_invoice_items_attributes_0_unit").val(productDataObj.unit)
      $("#invoice_invoice_items_attributes_0_unit_price").val(
        productDataObj.price)
      $("#invoice_invoice_items_attributes_0_vat").val(productDataObj.vat)
