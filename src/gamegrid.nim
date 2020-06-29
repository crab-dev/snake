type
  Row = seq[Tile]
  Tile* = tuple[col, row: int]
  Grid* = object
    rows: seq[Row]
    numRows*: int
    numCols*: int

proc newGrid*(cols, rows: int): Grid =
  result.numRows = rows
  result.numCols = cols
  for r in countup(0, rows - 1):
    var row: Row = @[]
    for c in countup(0, cols - 1):
      row.add((c, r))
    result.rows.add(row)




