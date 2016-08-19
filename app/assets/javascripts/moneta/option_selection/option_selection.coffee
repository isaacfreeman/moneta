# TODO: Optional constructor arguments, or use defaults for standard Solidus front end
class VariantSelector
  constructor: (productForm) ->
    @productForm = productForm
    variantsContainer = @productForm.find('ul') # Container for the list of variants
    @variantElements = variantsContainer.find('li') # Elements representing variants
    @variantInputs = @variantElements.find('input[name=variant_id]')
    @notAvailableElement = @productForm.find('.not_available')
    @addToCartElement = @productForm.find('.add-to-cart')

  # TODO: flash of unstyled content shows variant rows while loading
  # TODO: DOn't show add-to-cart controls if variant is out of stock
  updateVariantsDisplay: () ->
    @hideNotAvailable()
    @hideVariants()
    @disableVariants()
    @hideAddToCartControls()
    @showSelectedVariants()
    @enableVisibleVariants()

  # Hide all variants and not-available message
  hideNotAvailable: () ->
    @notAvailableElement.hide() # Element to show when there's no matching variants

  # Hide all variants
  hideVariants: () ->
    @variantElements.hide()

  # Ensure that all variants are unselected, so they can't be accidentally
  # added to the cart.
  disableVariants: () ->
    @variantInputs.prop('checked', false)

  # Hide add-to-cart button and related controls while there are no variants visible
  hideAddToCartControls: () ->
    @addToCartElement.hide()

  # Show variantElements that have the selected optionValues
  showSelectedVariants: () ->
    for variant in @variantElements
      if @shouldShowVariantRow($(variant))
        $(variant).show()

  # Select visible variants so the can be added to cart
  # In the default Solidus front end we use radio buttons here, so if there
  # are multiple matches, only one will be selected. The user can still
  # manually select from the visible options.
  enableVisibleVariants: () ->
    visibleVariantElements = @variantElements.filter(':visible')
    if visibleVariantElements.length == 0
      @notAvailableElement.show()
    else
      visibleVariantElements.find('input[name=variant_id]').prop('checked', true)
      @showAddToCartControls()
      if visibleVariantElements.length == 1
        # We've narrowed the selection down to a single variant, so we can do
        # things that apply to that variant.
        variantElement = $(visibleVariantElements[0]).find('input[name=variant_id]')
        Spree.showVariantImages variantElement.attr('value')
        Spree.updateVariantPrice variantElement


  showAddToCartControls: () ->
    @addToCartElement.show()

  shouldShowVariantRow: (variant) ->
    matchesOptionValues = true
    for optionType, optionValue of @currentSelectedOptionValues()
      dataForOptionType = variant.data('option-'+optionType)
      if typeof(dataForOptionType)== 'undefined'
        # We don't have a value for this option type, so err on the side of
        # displaying the row
        continue
      if dataForOptionType.toString() != optionValue.toString()
        matchesOptionValues = false
    return matchesOptionValues

  currentSelectedOptionValues: () ->
    optionValues = []
    @productForm.find('select.option_type').each ->
      optionValues[$(this).data('option-type-id')] = $(this).val()
    return optionValues

class SwatchSelector
  constructor: (swatchButtonGroupElement, productForm, variantSelector) ->
    optionTypeName = swatchButtonGroupElement.data('option-type-name')
    selectElement = productForm.find('select.option_type-'+optionTypeName)
    swatchButtons = swatchButtonGroupElement.find('.option_value')

    swatchButtons.on 'click', (e) ->
      e.preventDefault()
      optionValue = $(this).data('option-value-name')
      selectElement.val(optionValue)
      swatchButtons.removeClass('active')
      $(this).addClass('active')
      variantSelector.updateVariantsDisplay()

    # Other JS may want to change the select, so we make sure the corresponding
    # swatch is selected
    selectElement.on 'change', ->
      optionValue = $(this).val()
      swatchElement = swatchButtonGroupElement.find('.option_value[data-option-value-name="' + optionValue + '"]')
      swatchButtons.removeClass('active')
      swatchElement.addClass('active')
      variantSelector.updateVariantsDisplay()

$(document).on 'ready turbolinks:load', ->
  if $('#product-options').length # If there's an options div
    productForm = $('#cart-form') # Element containing variants, option selectors and add-to-cart controls
    variantSelector = new VariantSelector(productForm)
    $('.option_type-color').each ->
      new SwatchSelector($(this), productForm, variantSelector)
    variantSelector.updateVariantsDisplay()
