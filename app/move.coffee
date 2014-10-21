Line = require('line')

class Move

  constructor: (game) ->
    @game = game
    @dots = []
    @lines = []
    @connections = {}
    @color = null
    Crafty.addEvent this, Crafty.stage.elem, "mouseup", this.complete

  complete: =>
    Crafty.removeEvent this, Crafty.stage.elem, "mouseup", this.complete
    this.destroyDots()
    this.destroyAllLines()
    this.updateGameState()
    this.dispose()

  updateGameState: =>
    if @dots.length > 1
      dotCount = this.getUniqueDotCount()
      @game.addPoints(dotCount * 10)
      @game.subtractMove()

  dispose: =>
    @game.move = null
    @lines = null
    @dots = null
    @connections = null

  destroyDots: =>
    if @dots.length > 1
      replacements = []
      uniqueDots = this.getUniqueDots()
      iterator = {}
      for id, dot of uniqueDots
        column = dot.column
        iterator[column] ||= 0
        iterator[column] += 1
        this.removeDot(dot)
        replacements.push({
          column: column,
          iterator: iterator[column]
        })
      replacements.forEach (data) =>
        this.addReplacementDot(data.column, data.iterator)

  addReplacementDot: (column, index) =>
    @game.addDotAt(-index, column)

  removeDot: (dot) =>
    @game.removeDot(dot)

  getUniqueDots: =>
    uniqueDots = {}
    for index, dot of @dots
      uniqueDots[dot.id] = dot
    uniqueDots

  getGroupedDots: =>
    uniqueDots = {}
    for index, dot of @dots
      uniqueDots[dot.id] ||= []
      uniqueDots[dot.id].push(dot)
    uniqueDots

  getUniqueDotCount: =>
    uniqueDots = this.getUniqueDots()
    count = 0
    for index, dot of uniqueDots
      count++
    count

  destroyAllLines: =>
    for line in @lines
      line.destroy()

  addDot: (dot) =>
    if @dots.length == 0
      this.addFirstDot(dot)
    else
      this.addNextDot(dot)

  addFirstDot: (dot) =>
    @color = dot.color
    this.addFreshDot(dot)

  addNextDot: (dot) =>
    # A dot must be of same color
    return if dot.color != @color
    currentDot = this.getCurrentDot()
    # A dot cannot connect to itself
    return if dot.id == currentDot.id
    # A dot must be adjacent
    return unless dot.adjacentTo(currentDot)
    previousDot = this.getPreviousDot()
    # If we're backtracking, jump out of here into backtrack mode
    return this.backtrack() if previousDot and previousDot.id == dot.id
    # Dots may not be already connected
    return if this.areDotsConnected(dot, currentDot)

    line = this.getCurrentLine()
    line.drawToLocation(dot.getMiddleX(), dot.getMiddleY())
    line.detachFromMouse()

    this.connectDots(dot, currentDot)
    this.addFreshDot(dot)

  backtrack: =>
    previousDot = this.getPreviousDot()
    previousLine = this.getPreviousLine()
    currentDot = this.removeCurrentDot()
    currentLine = this.removeCurrentLine()
    currentLine.destroy()
    previousLine.attachToMouse()
    this.disconnectDots(previousDot, currentDot)

  getCurrentDot: =>
    @dots[@dots.length - 1]

  removeCurrentDot: =>
    @dots.pop()

  getPreviousDot: =>
    @dots[@dots.length - 2]

  getCurrentLine: =>
    @lines[@lines.length - 1]

  removeCurrentLine: =>
    @lines.pop()

  getPreviousLine: =>
    @lines[@lines.length - 2]

  connectDots: (dotA, dotB) =>
    [lower, higher] = [dotA.id, dotB.id].sort()
    @connections[lower] ||= {}
    @connections[lower][higher] = true

  disconnectDots: (dotA, dotB) =>
    [lower, higher] = [dotA.id, dotB.id].sort()
    @connections[lower] ||= {}
    delete @connections[lower][higher]

  areDotsConnected: (dotA, dotB) =>
    [lower, higher] = [dotA.id, dotB.id].sort()
    @connections[lower] and @connections[lower][higher]

  addFreshDot: (dot) =>
    line = new Line({
      color: @color,
      x: dot.getMiddleX(),
      y: dot.getMiddleY(),
      movesWithMouse: true
    })
    line.draw()
    @lines.push(line)
    @dots.push(dot)

module.exports = Move

