Colors = require('colors')
Dot = require('dot')
Level = require('level')
Entity = require('entity')
Popup = require('popup')

Crafty.c("Platform")

class Game
  @WIDTH: 640

  @currentGame: null
  @startNewGame: ->
    Popup.hide()
    if Game.currentGame
      Game.currentGame.dispose()
    $('#start-screen').hide()
    $gameEl = $('#game-screen')
    $gameEl.show()
    gameEl = $gameEl.find('#game').get(0)
    game = new Game(gameEl)
    Game.currentGame = game
    game.start()

  constructor: (container, options = {}) ->
    @container = container
    @level = options.level || new Level()
    @score = 0
    @moves = @level.moves
    @dots = []

  dispose: =>
    @level = null
    @container = null

  start: =>
    this.initGameArea()
    this.drawPlatform()
    this.drawDots()
    this.updateMoveCounter()
    this.updateScore()

  addPoints: (points) =>
    @score += points
    this.updateScore()

  subtractMove: =>
    @moves -= 1
    this.updateMoveCounter()
    if @moves == 0
      Popup.show(@score)

  updateMoveCounter: =>
    $('.limitation .count').text(@moves)

  updateScore: =>
    $('.score .count').text(@score)

  windowHeight: =>
    $(window).height()

  initGameArea: =>
    Crafty("*").each -> this.destroy()
    #Crafty.stop(true)
    unless Crafty.initialized
      Crafty.init(Game.WIDTH, this.windowHeight(), @container)
      Crafty.background('rgb(255, 255, 255)')
      Crafty.initialized = true

  drawPlatform: =>
    # Put the platform in a place which will place
    # the dots in the middle of the screen
    y = (this.windowHeight() / 2) + (@level.height * Entity.HEIGHT / 2)
    entity = Crafty.e("Platform, 2D, DOM, Color, Collision")
    entity.color('#fff')
    entity.attr({ x: 0, y: y, w: Game.WIDTH, h: 1 })

  drawDots: =>
    for row in [0...@level.height]
      for column in [0...@level.width]
        this.addDotAt(row, column)

  addDotAt: (row, column) =>
    # row - 1 gives a nice drop effect when the dot
    # is introduced to the stage
    dot = new Dot(this, {
      row: row - 1,
      column: column
    })
    dot.draw()
    @dots.push dot

  removeDot: (dot) =>
    index = @dots.indexOf(dot)
    @dots.splice(index, 1)
    dot.destroy()

module.exports = Game

