extends TileMapLayer

var obstacleMap:PackedColorArray
var size:Vector2i
var playerSpawnPosition = Vector2i(0,0)
var foodSpawnLocations:Array[Vector2i] = []
var enemySpawnerLocations:Array[Vector2i] = []

signal FinishedPlacingTiles

# used to reduce iterations for spawning stuff
const MAP_LOWER_LIMIT = 3
const MAP_UPPER_LIMIT = 97
const MaxFoodSpawners = 20

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
	setPlayerSpawnLocation()
	setFoodSpawnerLocations()
	setEnemySpawnerLocations()
	FinishedPlacingTiles.emit()

func setPlayerSpawnLocation():
	var isPlayerSpawnable = false
	var usedCells:Array[Vector2i] = get_used_cells()
	var tempX = 0
	var tempY = 0
	while !isPlayerSpawnable:
		if usedCells.find(playerSpawnPosition) != -1:
			tempX = randi_range(MAP_LOWER_LIMIT,MAP_UPPER_LIMIT)
			tempY = randi_range(MAP_LOWER_LIMIT,MAP_UPPER_LIMIT)
			playerSpawnPosition = Vector2i(tempX,tempY)
		else:
			isPlayerSpawnable = true

func setFoodSpawnerLocations():
	var foodLocation = Vector2i(0,0)
	var usedCells:Array[Vector2i] = get_used_cells()
	var tempX = 0
	var tempY = 0
	var currentFoodIndex = 0
	while MaxFoodSpawners != currentFoodIndex:
		if usedCells.find(foodLocation) != -1 and !foodSpawnLocations.has(foodLocation) and !enemySpawnerLocations.has(foodLocation):
			tempX = randi_range(MAP_LOWER_LIMIT,MAP_UPPER_LIMIT)
			tempY = randi_range(MAP_LOWER_LIMIT,MAP_UPPER_LIMIT)
			foodLocation = Vector2i(tempX,tempY)
		else:
			foodSpawnLocations.append(foodLocation)
			foodLocation = Vector2i.ZERO
			currentFoodIndex += 1
	print_debug(foodSpawnLocations)

func setEnemySpawnerLocations():
	var enemySpawnerLocation = Vector2i(0,0)
	var usedCells:Array[Vector2i] = get_used_cells()
	var tempX = 0
	var tempY = 0
	var currentFoodIndex = 0
	while MaxFoodSpawners != currentFoodIndex:
		if usedCells.find(enemySpawnerLocation) != -1 and !enemySpawnerLocations.has(enemySpawnerLocation) and !foodSpawnLocations.has(enemySpawnerLocation):
			tempX = randi_range(MAP_LOWER_LIMIT,MAP_UPPER_LIMIT)
			tempY = randi_range(MAP_LOWER_LIMIT,MAP_UPPER_LIMIT)
			enemySpawnerLocation = Vector2i(tempX,tempY)
		else:
			enemySpawnerLocations.append(enemySpawnerLocation)
			enemySpawnerLocation = Vector2i.ZERO
			currentFoodIndex += 1
	print_debug(enemySpawnerLocations)

func getPlayerSpawnPosition():
	var globalPlayerPosition = map_to_local(playerSpawnPosition)
	return to_global(globalPlayerPosition)

func getFoodSpawnerPositions():
	var globalFoodSpawnerPositions = []
	for pos in foodSpawnLocations:
		var globalFoodPosition = map_to_local(pos)
		globalFoodSpawnerPositions.append(to_global(globalFoodPosition))
	return globalFoodSpawnerPositions

func getEnemySpawnerPositions():
	var globalEnemySpawnerPositions = []
	for pos in foodSpawnLocations:
		var globalEnemySpawnerPosition = map_to_local(pos)
		globalEnemySpawnerPositions.append(to_global(globalEnemySpawnerPosition))
	return globalEnemySpawnerPositions
