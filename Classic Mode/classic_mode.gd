extends Node

@onready var obstacle_spawner: Node2D = $ObstacleSpawner
@onready var wall_tile_map = $WallTileMap
func _ready() -> void:
	obstacle_spawner.connect("GeneratedNoise",OnFinishNoise)
	wall_tile_map.connect("FinishedPlacingTiles", OnFinishWallPlacement)
	obstacle_spawner.GenerateAndClean()

func OnFinishNoise():
	wall_tile_map.obstacleMap = obstacle_spawner.colors
	wall_tile_map.size = obstacle_spawner.NoiseSize
	wall_tile_map.PlaceTiles()

func OnFinishWallPlacement():
	var player = (get_tree().get_first_node_in_group("Player") as Player)
	if player:
		player.global_position = wall_tile_map.getPlayerSpawnPosition()
	
	for foodSpawnerPos in wall_tile_map.getFoodSpawnerPositions():
		print("Spawned: ", foodSpawnerPos)
	pass
