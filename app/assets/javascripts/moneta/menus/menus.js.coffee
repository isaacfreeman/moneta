$('.btn-menu').on 'click', ->
  $('#navbar-primary-collapse')[0].scrollIntoView()

# Add fade-in-on-hover effect to menus if the menu button isn't visible
$(document).on('mouseenter', '.menu-hoverable ul.nav > li.dropdown', ->
  unless $('.btn-menu:visible').length
    $(this).find('.dropdown-menu').first().stop(true, true).fadeIn(600)
    $(this).addClass('open')
    $(this).find('.dropdown-toggle').attr('aria-expanded', true)

).on('mouseleave', '.menu-hoverable ul.nav > li.dropdown', ->
  unless $('.btn-menu:visible').length
    $(this).find('.dropdown-menu').first().stop(true, true).fadeOut(300)
    $(this).removeClass('open')
    $(this).find('.dropdown-toggle').attr('aria-expanded', false)
)
$(document).on('click', '.menu-hoverable ul.nav > li.dropdown > a', ->
  $link = $(this)
  if $link.closest('li.dropdown').hasClass('open')
    if $link.attr('href')
      location.href = $link.attr('href')
)
