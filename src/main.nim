import nico, random, gamegrid, gamesnake, deques

const
  tileSize = 8
  updateInterval = 0.2

var 
  grid = newGrid(20, 20)
  snake: Snake
  cherry: Tile
  direction = Right
  timeElapsedSinceUpdate = 0.0
  score = 0
  isRunning = false
  
proc getRandomLocation(): Tile =
  return (
    rand(grid.numCols - 1),
    rand(grid.numRows - 1)
  )

proc reset() =
  isRunning = true
  cherry = getRandomLocation()
  snake = newSnake(@[(3, 6), (3, 7), (2, 7), (2, 8)])
  isRunning = true
  score = 0

proc gameInit() =
  loadFont(0, "font.png")
  reset()
  
proc drawSnake() =
  for b in snake.body:
    boxfill(b.col * tileSize, b.row * tileSize, tileSize, tileSize)

proc drawCherry() = 
  let 
    x = cherry.col * tileSize + tileSize / 2
    y = cherry.row * tileSize + tileSize / 2 
  circfill(x, y, tileSize / 4)

proc stop() =
  isRunning = false

proc update() =
  let nextTile = snake.getNextTile(direction)
  if nextTile.col < 0 or nextTile.row < 0 or nextTile.col == grid.numCols or nextTile.row == grid.numRows or
    snake.body.contains(nextTile) and nextTile != snake.body.peekLast():
    stop()
    return

  snake.move(direction)

  if nextTile == cherry:
    cherry = getRandomLocation()
    snake.body.addLast(snake.nextTailPosition)
    inc score

proc up(): bool =
  return key(K_UP) or key(K_w)

proc down(): bool =
  return key(K_DOWN) or key(K_s)

proc left(): bool =
  return key(K_LEFT) or key(K_a)

proc right(): bool =
  return key(K_RIGHT) or key(K_d)

proc gameUpdate(dt: float32) =
  if not isRunning:
    if key(K_SPACE):
      reset()
      isRunning = true
    return

  if up() and direction != Down:
    direction = Up
  elif down() and direction != Up:
    direction = Down
  elif left() and direction != Right:
    direction = Left
  elif right() and direction != Left:
    direction = Right

  timeElapsedSinceUpdate += dt
  if timeElapsedSinceUpdate >= updateInterval:
    update()
    timeElapsedSinceUpdate = timeElapsedSinceUpdate mod updateInterval

proc gameDraw() =
  cls()
  setColor(3)
  boxfill(0, 0, grid.numCols * tileSize, grid.numRows * tileSize)
  setColor(1)
  drawSnake()
  setColor(2)
  drawCherry()
  print($score, tileSize / 2, tileSize / 2)
  if not isRunning:
    printc("Game Over!", grid.numCols / 2 * tileSize, grid.numRows / 2 * tileSize - tileSize / 2)
    printc("Press Space to Play Again", grid.numCols / 2 * tileSize, grid.numRows / 2 * tileSize + tileSize / 2)

nico.init("myOrg", "myApp")
nico.createWindow("myApp", grid.numCols * tileSize, grid.numRows * tileSize, 4, false)
nico.run(gameInit, gameUpdate, gameDraw)
