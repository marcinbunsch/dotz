Move = require('move')

class MoveWithSquares extends Move

  complete: =>
    if this.squarePresent()
      this.addAllSameColoredDots()
    super()

  squarePresent: =>
    groupedDots = this.getGroupedDots()
    for id, dots of groupedDots
      return true if dots.length > 1
    return false

  addAllSameColoredDots: =>
    uniqueDots = this.getUniqueDots()
    @game.dots.forEach (dot) =>
      if dot.color == @color and !uniqueDots[dot.id]
        @dots.push(dot)

module.exports = MoveWithSquares
