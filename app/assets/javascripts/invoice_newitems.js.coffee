
# counter
counter = 1
itemCounter = ->
  counter = counter + 1


window.addItemField = ->


  #create Date object
  date = new Date

  #get number of milliseconds since midnight Jan 1, 1970
  #and use it for address key
  mSec = date.getTime()

  # Create unique id and name for fields
  # by replacing 0 with milliseconds
  idAttributProdSelect = 'prodSelect_0'.
                          replace('0', mSec)
  nameAttributProdSelect = 'prodSelect[0]'.
                            replace('0', mSec)
  idAttributDescription = 'invoice_invoice_items_attributes_0_description'.
                          replace('0', mSec)
  nameAttributDescription = 'invoice[invoice_items_attributes][0][description]'.
                            replace('0', mSec)
  idAttributQuantity = 'invoice_invoice_items_attributes_0_quantity'.
                        replace('0', mSec)
  nameAttributQuantity = 'invoice[invoice_items_attributes][0][quantity]'.
                          replace('0', mSec)
  idAttributUnit = 'invoice_invoice_items_attributes_0_unit'.
                    replace('0', mSec)
  nameAttributUnit = 'invoice[invoice_items_attributes][0][unit]'.
                      replace('0', mSec)
  idAttributPrice = 'invoice_invoice_items_attributes_0_unit_price'.
                    replace('0', mSec)
  nameAttributPrice = 'invoice[invoice_items_attributes][0][unit_price]'.
                      replace('0', mSec)
  idAttributVat = 'invoice_invoice_items_attributes_0_vat'.
                  replace('0', mSec)
  nameAttributVat = 'invoice[invoice_items_attributes][0][vat]'.
                    replace('0', mSec)

  #create main container div tag
  div = document.createElement('div')
  div.className = 'itempadding grad'
  div.id = 'item_' + itemCounter()

  # ---------- HEADING -------------
  itemHeading = document.createElement('h3')
  itemHeadingText = document.createTextNode('Produkt/Tjeneste')
  itemHeading.appendChild itemHeadingText
  div.appendChild itemHeading

  # ---------- PRODUCT SELECT -----------

  # create form-group div
  prodSelectDiv = document.createElement('div')
  prodSelectDiv.className = 'form-group'

  #create label, set it's for attribute,
  #and append it to form-group div
  labelProdSelect = document.createElement('label')
  labelProdSelect.className = 'col-sm-3 control-label'
  labelProdSelect.setAttribute 'for', idAttributProdSelect
  prodSelectLabelText = document.createTextNode('')
  labelProdSelect.appendChild prodSelectLabelText
  prodSelectDiv.appendChild labelProdSelect

  #create input div
  prodSelectInputDiv = document.createElement('div')
  prodSelectInputDiv.className = 'col-sm-9'

  #create input, set it's type, id and name attribute,
  inputProdSelect = document.createElement('SELECT')
  inputProdSelect.className = 'form-control'
  inputProdSelect.setAttribute 'id', idAttributProdSelect
  inputProdSelect.setAttribute 'name', nameAttributProdSelect

  #create options and append to select
  velgProd = document.createElement('OPTION')
  velgProd.setAttribute 'value', ''
  prodDefaultText = document.createTextNode('Hent fra produktregister')
  velgProd.appendChild prodDefaultText
  inputProdSelect.appendChild velgProd
  userProducts.forEach (product) ->
    prodID = product.id
    prodNr = product.product_number
    prodDesc = product.description
    prodValg = document.createElement('OPTION')
    prodValg.setAttribute 'value', product.id
    prodDescription = document.createTextNode('[' + prodNr + '] ' + prodDesc)
    prodValg.appendChild prodDescription
    inputProdSelect.appendChild prodValg
    return

  #and append it to input div
  prodSelectInputDiv.appendChild inputProdSelect

  # append input group to form-group
  prodSelectDiv.appendChild prodSelectInputDiv

  # append form-group to main div
  div.appendChild prodSelectDiv

  # ---------- QUANTITY -----------

  # create form-group div
  quantityDiv = document.createElement('div')
  quantityDiv.className = 'form-group'

  #create label, set it's for attribute,
  #and append it to form-group div
  labelQuantity = document.createElement('label')
  labelQuantity.className = 'col-sm-3 control-label'
  labelQuantity.setAttribute 'for', idAttributQuantity
  quantityLabelText = document.createTextNode('Antall *')
  labelQuantity.appendChild quantityLabelText
  quantityDiv.appendChild labelQuantity

  #create input div
  quantityInputDiv = document.createElement('div')
  quantityInputDiv.className = 'col-sm-9'

  #create input, set it's type, id and name attribute,
  #and append it to input div
  inputQuantity = document.createElement('INPUT')
  inputQuantity.className = 'form-control'
  inputQuantity.setAttribute 'type', 'text'
  inputQuantity.setAttribute 'id', idAttributQuantity
  inputQuantity.setAttribute 'name', nameAttributQuantity
  quantityInputDiv.appendChild inputQuantity

  # append input div to form-group
  quantityDiv.appendChild quantityInputDiv

  # append form-group to main div
  div.appendChild quantityDiv

  # ---------- UNIT -----------

  # create form-group div
  unitDiv = document.createElement('div')
  unitDiv.className = 'form-group'

  #create label, set it's for attribute,
  #and append it to form-group div
  labelUnit = document.createElement('label')
  labelUnit.className = 'col-sm-3 control-label'
  labelUnit.setAttribute 'for', idAttributUnit
  unitLabelText = document.createTextNode('Enhet (timer, kg, ...) *')
  labelUnit.appendChild unitLabelText
  unitDiv.appendChild labelUnit

  #create input div
  unitInputDiv = document.createElement('div')
  unitInputDiv.className = 'col-sm-9'

  #create input, set it's type, id and name attribute,
  #and append it to input div
  inputUnit = document.createElement('INPUT')
  inputUnit.className = 'form-control'
  inputUnit.setAttribute 'type', 'text'
  inputUnit.setAttribute 'id', idAttributUnit
  inputUnit.setAttribute 'name', nameAttributUnit
  unitInputDiv.appendChild inputUnit

  # append input div to form-group
  unitDiv.appendChild unitInputDiv

  # append form-group to main div
  div.appendChild unitDiv

  # ---------- DESCRIPTION -----------

  # create form-group div
  descriptionDiv = document.createElement('div')
  descriptionDiv.className = 'form-group'

  #create label, set it's for attribute,
  #and append it to form-group div
  labelDescription = document.createElement('label')
  labelDescription.className = 'col-sm-3 control-label'
  labelDescription.setAttribute 'for', idAttributDescription
  descriptionLabelText = document.createTextNode('Beskrivelse *')
  labelDescription.appendChild descriptionLabelText
  descriptionDiv.appendChild labelDescription

  #create input div
  descriptionInputDiv = document.createElement('div')
  descriptionInputDiv.className = 'col-sm-9'

  #create input, set it's type, id and name attribute,
  #and append it to input div
  inputDescription = document.createElement('INPUT')
  inputDescription.className = 'form-control'
  inputDescription.setAttribute 'type', 'text'
  inputDescription.setAttribute 'id', idAttributDescription
  inputDescription.setAttribute 'name', nameAttributDescription
  descriptionInputDiv.appendChild inputDescription

  # append input div to form-group
  descriptionDiv.appendChild descriptionInputDiv

  # append form-group to main div
  div.appendChild descriptionDiv

  # ---------- UNIT PRICE -----------

  # create form-group div
  priceDiv = document.createElement('div')
  priceDiv.className = 'form-group'

  #create label, set it's for attribute,
  #and append it to form-group div
  labelPrice = document.createElement('label')
  labelPrice.className = 'col-sm-3 control-label'
  labelPrice.setAttribute 'for', idAttributPrice
  priceLabelText = document.createTextNode('Pris per enhet *')
  labelPrice.appendChild priceLabelText
  priceDiv.appendChild labelPrice

  #create input div
  priceInputDiv = document.createElement('div')
  priceInputDiv.className = 'col-sm-9'

  #create input group div
  priceInputGroupDiv = document.createElement('div')
  priceInputGroupDiv.className = 'input-group'

  #create input, set it's type, id and name attribute,
  #and append it to input div
  inputPrice = document.createElement('INPUT')
  inputPrice.className = 'form-control'
  inputPrice.setAttribute 'type', 'text'
  inputPrice.setAttribute 'id', idAttributPrice
  inputPrice.setAttribute 'name', nameAttributPrice
  priceInputGroupDiv.appendChild inputPrice

  # create input addon div, append text and append to input group
  priceInputAddonDiv = document.createElement('div')
  priceInputAddonDiv.className = 'input-group-addon'
  priceAddonText = document.createTextNode('kr')
  priceInputAddonDiv.appendChild priceAddonText
  priceInputGroupDiv.appendChild priceInputAddonDiv

  # append input div to input group
  priceInputDiv.appendChild priceInputGroupDiv

  # append input group to form-group
  priceDiv.appendChild priceInputDiv

  # append form-group to main div
  div.appendChild priceDiv

  # ---------- VAT -----------

  # create form-group div
  vatDiv = document.createElement('div')
  vatDiv.className = 'form-group'

  #create label, set it's for attribute,
  #and append it to form-group div
  labelVat = document.createElement('label')
  labelVat.className = 'col-sm-3 control-label'
  labelVat.setAttribute 'for', idAttributVat
  vatLabelText = document.createTextNode('MVA *')
  labelVat.appendChild vatLabelText
  vatDiv.appendChild labelVat

  #create input div
  vatInputDiv = document.createElement('div')
  vatInputDiv.className = 'col-sm-9'

  #create input, set it's type, id and name attribute,
  inputVat = document.createElement('SELECT')
  inputVat.className = 'form-control'
  inputVat.setAttribute 'id', idAttributVat
  inputVat.setAttribute 'name', nameAttributVat

  #create options and append to select
  velgVat = document.createElement('OPTION')
  velgVat.setAttribute 'value', ''
  vatDefaultText = document.createTextNode('Velg mva-sats')
  velgVat.appendChild vatDefaultText
  inputVat.appendChild velgVat
  vat0 = document.createElement('OPTION')
  vat0.setAttribute 'value', '0'
  vat0Text = document.createTextNode('0%')
  vat0.appendChild vat0Text
  inputVat.appendChild vat0
  vat8 = document.createElement('OPTION')
  vat8.setAttribute 'value', '8'
  vat8Text = document.createTextNode('8%')
  vat8.appendChild vat8Text
  inputVat.appendChild vat8
  vat15 = document.createElement('OPTION')
  vat15.setAttribute 'value', '15'
  vat15Text = document.createTextNode('15%')
  vat15.appendChild vat15Text
  inputVat.appendChild vat15
  vat25 = document.createElement('OPTION')
  vat25.setAttribute 'value', '25'
  vat25Text = document.createTextNode('25%')
  vat25.appendChild vat25Text
  inputVat.appendChild vat25

  #and append it to input div
  vatInputDiv.appendChild inputVat

  # append input group to form-group
  vatDiv.appendChild vatInputDiv

  # append form-group to main div
  div.appendChild vatDiv

  # ---------- ADD ALL TO MAIN DIV -----------
  document.getElementById('itemList').appendChild div

  # ----------- FUNCTION FOR AUTOFILLING SELECTED PRODUCT ------------

  jQuery ->
    $('#' + idAttributProdSelect).change ->
      $.get '/products/' + $(this).val() + '/product_json', (data, status, xhr) ->
        productsDataObj = undefined
        productsDataObj = JSON.parse(data)
        $('#' + idAttributDescription).val productsDataObj.description
        $('#' + idAttributUnit).val productsDataObj.unit
        $('#' + idAttributPrice).val productsDataObj.price
        $('#' + idAttributVat).val productsDataObj.vat