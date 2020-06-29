import nico, random, gamegrid, gamesnake

const
  tileSize = 8
  updateInterval = 0.5

var 
  grid = newGrid(20, 20)
  snake: Snake
  cherry: Tile
  direction = Right
  timeElapsedSinceUpdate = 0.0
  
proc getRandomLocation(): Tile =
  return (
    rand(grid.numCols - 1),
    rand(grid.numRows - 1)
  )

proc gameInit() =
  loadFont(0, "font.png")
  cherry = getRandomLocation()
  snake = newSnake(@[(3, 6), (3, 7), (2, 7), (2, 8)])

proc drawSnake() =
  for x in snake.body:
    echo "a"
  # boxfill(b.col * tileSize, b.row * tileSize, tileSize, tileSize)

proc drawCherry() = 
  let 
    x = cherry.col * tileSize + tileSize / 2
    y = cherry.row * tileSize + tileSize / 2 
  circfill(x, y, tileSize / 4)

proc update() =
  snake.move(direction)

proc gameUpdate(dt: float32) =
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

nico.init("myOrg", "myApp")
nico.createWindow("myApp", grid.numCols * tileSize, grid.numRows * tileSize, 1, false)
nico.run(gameInit, gameUpdate, gameDraw)
