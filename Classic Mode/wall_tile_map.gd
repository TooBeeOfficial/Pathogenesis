extends TileMapLayer

var obstacleMap:PackedColorArray
var size:Vector2i

signal FinishedPlacingTiles

func PlaceTiles():
	var cells:Array[Vector2i] = []
	var xCoordinate = 0
	var yCoordinate = 0
	for color in obstacleMap:
		if (color as Color).b > 0:
			set_cell(Vector2i(xCoordinate,yCoordinate),0,Vector2i(0,0))
			cells.append(Vector2i(xCoordinate,yCoordinate))
		xCoordinate += 1
		if xCoordinate % size.x == 0:
			yCoordinate += 1
			xCoordinate -= size.x
	set_cells_terrain_connect(cells,0,0)
	update_internals()
	FinishedPlacingTiles.emit()
