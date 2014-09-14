Entity = require('entity')

class Line extends Entity
  @HEIGHT: 10
  @HEIGHT_HALF = @HEIGHT / 2

  constructor: (options = {}) ->
    @startPoint = {
      x: options.x || 300,
      y: options.y || 300
    }
    @color = options.color
    @movesWithMouse = options.movesWithMouse
    @onComplete = options.onComplete || ->
    @offset = $(Crafty.stage.elem).offset()

  destroy: =>
    this.onComplete()
    @entity.destroy()
    @entity = null
    @offset = null
    this.detachFromMouse()

  attachToMouse: =>
    Crafty.addEvent this, Crafty.stage.elem, "mousemove", this.onMouseMove
    @movesWithMouse = true

  detachFromMouse: =>
    Crafty.removeEvent this, Crafty.stage.elem, "mousemove", this.onMouseMove
    @movesWithMouse = false

  draw: =>
    @entity = this.createEntity()
    if @movesWithMouse
      this.attachToMouse()

  createEntity: =>
    Crafty.e("Line, Mouse, 2D, DOM, Color")
      .color(@color)
      .origin(0, Line.HEIGHT_HALF)
      .attr({
        x: @startPoint.x,
        y: @startPoint.y - Line.HEIGHT_HALF,
        w: 0,
        h: Line.HEIGHT
      })

  onMouseMove: (e) =>
    x = e.x - @offset.left
    y = e.y - @offset.top + $(window).scrollTop()
    this.drawToLocation(x, y)

  drawToLocation: (x,y) =>
    distance_x = x - @startPoint.x
    distance_y = y - @startPoint.y

    sum = Math.pow(distance_x, 2) + Math.pow(distance_y, 2)
    length = Math.sqrt(sum)

    angle = Math.atan2(distance_y, distance_x) * 180 / Math.PI

    @entity.attr({
      w: length,
      rotation: angle
    })

module.exports = Line
