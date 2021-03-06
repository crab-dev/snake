import nico, random, gamegrid, gamesnake, audioplayer, deques

const
  tileSize = 8
  updateInterval = 0.15

var 
  grid = newGrid(20, 20)
  snake: Snake
  cherry: Tile
  anticipatedDirection = Right
  timeElapsedSinceUpdate = 0.0
  score = 0
  isRunning = false
  firstRun = true
  
proc getRandomLocation(): Tile =
  return (
    rand(grid.numCols - 1),
    rand(grid.numRows - 1)
  )

proc reset() =
  # 1 loops the track
  playMusicTrack()
  isRunning = true
  var newLocation = getRandomLocation()
  while cherry == newLocation:
    newLocation = getRandomLocation()
  cherry = newLocation
  snake = newSnake(@[(3, 6), (3, 7), (2, 7), (2, 8)])
  anticipatedDirection = Right
  snake.direction = anticipatedDirection
  isRunning = true
  score = 0

proc gameInit() =
  loadFont(0, "font.png")
  loadAudioFiles()
  
proc drawSnake() =
  for b in snake.body:
    boxfill(b.col * tileSize, b.row * tileSize, tileSize, tileSize)

proc drawCherry() = 
  let 
    x = cherry.col * tileSize + tileSize / 2
    y = cherry.row * tileSize + tileSize / 2 
  circfill(x, y, tileSize / 4)

proc stopGame() =
  playSound()
  stopMusicTrack()
  isRunning = false

proc canMoveTo(nextTile: Tile): bool =
  return
    nextTile.col >= 0 and nextTile.row >= 0 and
    nextTile.col < grid.numCols and nextTile.row < grid.numRows and
    (not snake.body.contains(nextTile) or nextTile == snake.body.peekLast())

proc update() =
  let nextTile = snake.getNextTile(anticipatedDirection)
  if not canMoveTo(nextTile):
    stopGame()
    return

  snake.move(anticipatedDirection)

  if nextTile == cherry:
    cherry = getRandomLocation()
    snake.body.addLast(snake.nextTailPosition)
    inc score

proc up(): bool =
  return btnp(pcUp) or key(K_w)

proc down(): bool =
  return btnp(pcDown) or key(K_s)

proc left(): bool =
  return btnp(pcLeft) or key(K_a)

proc right(): bool =
  return btnp(pcRight) or key(K_d)

proc gameUpdate(dt: float32) =
  if not isRunning:
    if key(K_SPACE):
      reset()
      isRunning = true
      firstRun = false
    return

  if up() and snake.direction != Down:
    anticipatedDirection = Up
  elif down() and snake.direction != Up:
    anticipatedDirection = Down
  elif left() and snake.direction != Right:
    anticipatedDirection = Left
  elif right() and snake.direction != Left:
    anticipatedDirection = Right

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
    if firstRun:
      printc("Press Space to Start", grid.numCols / 2 * tileSize, grid.numRows / 2 * tileSize + tileSize / 2)
    else:
      printc("Game Over!", grid.numCols / 2 * tileSize, grid.numRows / 2 * tileSize - tileSize / 2)
      printc("Press Space to Play Again", grid.numCols / 2 * tileSize, grid.numRows / 2 * tileSize + tileSize / 2)

nico.init("myOrg", "myApp")
nico.createWindow("myApp", grid.numCols * tileSize, grid.numRows * tileSize, 4, false)
nico.run(gameInit, gameUpdate, gameDraw)
