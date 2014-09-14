Colors = require('colors')
Entity = require('entity')
Move = require('move')

class Dot extends Entity

  @WIDTH = 20
  @HEIGHT = 20
  @RADIUS = 36
  @RADIUS_HALF = Dot.RADIUS / 2
  @RADIUS_QUARTER = Dot.RADIUS / 4

  # id factory
  @lastId = 0
  @getId = -> this.lastId += 1

  constructor: (game, options = {}) ->
    @game = game
    @color = options.color || Colors.random()
    @row = options.row
    @column = options.column
    @id = Dot.getId()

  draw: =>
    @entity = this.createEntity()
    @entity.bind('MouseDown', this.onMouseDown)
    @entity.bind('MouseOver', this.onMouseOver)

  destroy: =>
    @entity.destroy()
    @game = null

  createEntity: =>
    x = @column * Entity.WIDTH
    y = @row * Entity.WIDTH

    @entity = Crafty.e("Dot, Mouse, Platform, 2D, HTML, DOM, Color, Collision, Gravity")
      .gravity("Platform")
      .gravityConst(2.5)
      .append(this.dotDiv())
      .attr({
        x: x,
        y: y,
        w: Entity.WIDTH,
        h: Entity.WIDTH
      })

  dotDiv: =>
    "<div style='height: #{Dot.RADIUS}px; width: #{Dot.RADIUS}px; margin-left: #{Entity.WIDTH_HALF - Dot.RADIUS_HALF}px;  margin-top: #{Entity.WIDTH_HALF - Dot.RADIUS_HALF}px;background-color: #{@color}; border-radius: #{Dot.RADIUS}px'></div>"

  onMouseDown: (e) =>
    e.preventDefault()
    @game.move = new Move(@game)
    @game.move.addDot(this)

  onMouseOver: =>
    @game.move.addDot(this) if @game.move

  getMiddleX: =>
    @entity._x + Entity.WIDTH_HALF

  getMiddleY: =>
    @entity._y + Entity.WIDTH_HALF

  getRow: =>
    @entity._x / Entity.WIDTH

  getColumn: =>
    @entity._y / Entity.WIDTH

  adjacentTo: (otherDot) =>
    dotRow = this.getRow()
    dotColumn = this.getColumn()
    otherDotRow = otherDot.getRow()
    otherDotColumn = otherDot.getColumn()
    if dotRow == otherDotRow
      dotColumn <= otherDotColumn + 1 and dotColumn >= otherDotColumn - 1
    else if dotColumn == otherDotColumn
      dotRow <= otherDotRow + 1 and dotRow >= otherDotRow - 1

module.exports = Dot
