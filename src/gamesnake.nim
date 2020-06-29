import deques, gamegrid

type 
  Snake* = object
    body*: Deque[Tile]
    nextTailPosition*: Tile

type
  Direction* = enum
    Up, Down, Left, Right
     
proc newSnake*(body: seq[Tile]): Snake =
  result.body = initDeque[Tile]()
  for tile in body:
    result.body.addLast(tile)
  result.nextTailPosition = result.body.peekLast

proc getNextTile*(this: Snake, direction: Direction): Tile =
  result = this.body.peekFirst
  case direction
  of Up:
    result.row -= 1
  of Down:
    result.row += 1
  of Left:
    result.col -= 1
  of Right:
    result.col += 1

proc move*(this: var Snake, direction: Direction) = 
  let nextTile = this.getNextTile(direction)
  this.body.addFirst(nextTile)
  this.nextTailPosition = this.body.popLast()
