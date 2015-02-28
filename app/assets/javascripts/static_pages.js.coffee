# Bounce scroll-down icons
setInterval (->
  $('.glyph-link-down').effect('bounce', { times: 2 }, 1500)
), 5000

# jQuery for page scrolling feature  on landing page
# Requires jQuery Easing plugin (gem)
$ ->
  $('a.page-scroll').bind 'click', (event) ->
    $anchor = $(this)
    $('html, body').stop().animate { scrollTop: $(
      $anchor.attr('href')).offset().top }, 1500, 'easeInOutExpo'
    event.preventDefault()

# Focus on email field in login modal
jQuery ->
  $('#modal-login-window').on('shown.bs.modal', ->
    $('#login-email').focus())
