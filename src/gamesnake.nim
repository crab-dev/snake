import deques, gamegrid

type 
  Snake* = object
    body*: Deque[Tile]

type
  Direction* = enum
    Up, Down, Left, Right
     
proc newSnake*(body: seq[Tile]): Snake =
  result.body = initDeque[Tile]()
  for tile in body:
    result.body.addLast(tile)

proc move*(this: var Snake, direction: Direction) = 
  var nextTile: Tile = this.body.peekFirst
  case direction
  of Up:
    nextTile.row -= 1
  of Down:
    nextTile.row += 1
  of Left:
    nextTile.col -= 1
  of Right:
    nextTile.col += 1
  this.body.addFirst(nextTile)
  this.body.popLast()
