# jQuery for page scrolling feature  on landing page
# Requires jQuery Easing plugin (gem)
$ ->
  $('a.page-scroll').bind 'click', (event) ->
    $anchor = $(this)
    $('html, body').stop().animate { scrollTop: $(
      $anchor.attr('href')).offset().top }, 1500, 'easeInOutExpo'
    event.preventDefault()
