extends Node

@onready var obstacle_spawner: Node2D = $ObstacleSpawner
@onready var wall_tile_map: TileMapLayer = $WallTileMap
var playerSpawnPosition:Vector2i = Vector2i(0,0)
var foodSpawnLocations:Array[Vector2i] = []
var enemySpawnerLocations:Array[Vector2i] = []

# used to reduce iterations for spawning stuff
const MAP_LOWER_LIMIT = 3
const MAP_UPPER_LIMIT = 97

func _ready() -> void:
	obstacle_spawner.connect("GeneratedNoise",OnFinishNoise)
	wall_tile_map.connect("FinishedPlacingTiles", OnFinishWallPlacement)
	obstacle_spawner.GenerateAndClean()

func OnFinishNoise():
	wall_tile_map.obstacleMap = obstacle_spawner.colors
	wall_tile_map.size = obstacle_spawner.NoiseSize
	wall_tile_map.PlaceTiles()

func OnFinishWallPlacement():
	var isPlayerSpawnable = false
	var usedCells:Array[Vector2i] = wall_tile_map.get_used_cells()
	var tempX = 0
	var tempY = 0
	while !isPlayerSpawnable:
		if usedCells.find(playerSpawnPosition) != -1:
			tempX = randi_range(MAP_LOWER_LIMIT,MAP_UPPER_LIMIT)
			tempY = randi_range(MAP_LOWER_LIMIT,MAP_UPPER_LIMIT)
			playerSpawnPosition = Vector2i(tempX,tempY)
		else:
			isPlayerSpawnable = true
	print_debug(playerSpawnPosition)
	pass
