Game = require('game')
Colors = require('colors')

$('a.button').css({
  'background-color': Colors.random()
})

$('.start a').click(Game.startNewGame)

