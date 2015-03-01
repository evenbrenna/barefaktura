# Bounce scroll-down icons
setInterval (->
  $('.glyph-link-down').effect('bounce', { times: 2 }, 1500)
), 5000

# jQuery for page scrolling feature  on landing page
# Requires jQuery-ui gem
$ ->
  $('a.page-scroll').on 'click', (event) ->
    $('html, body').stop().animate { scrollTop: $(
      $(this).attr('href')).offset().top }, 1500, 'easeInOutExpo'
    setInterval.stop() # prevents focus that makes page jump back on animation
    event.preventDefault()

# Focus on email field in login modal
jQuery ->
  $('#modal-login-window').on('shown.bs.modal', ->
    $('#login-email').focus())
