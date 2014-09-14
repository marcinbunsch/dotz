Popup = {}

Popup.show = (score) ->
  $('.popup .result').text(score)
  $('.popup').show()
  $('.popup-background').show()

Popup.hide = () ->
  $('.popup').hide()
  $('.popup-background').hide()

module.exports = Popup

