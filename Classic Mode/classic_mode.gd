extends Node

@onready var obstacle_spawner = $ObstacleSpawner
@onready var wall_tile_map = $WallTileMap
var foodSpawner = preload("res://Scenes/FoodSpawner.tscn")

func _ready() -> void:
	obstacle_spawner.connect("GeneratedNoise",OnFinishNoise)
	wall_tile_map.connect("FinishedPlacingTiles", OnFinishWallPlacement)
	obstacle_spawner.GenerateAndClean()

func OnFinishNoise():
	wall_tile_map.obstacleMap = obstacle_spawner.colors
	wall_tile_map.size = obstacle_spawner.NoiseSize
	wall_tile_map.PlaceTiles(obstacle_spawner.getPlayableArea())

func OnFinishWallPlacement():
	var player = (get_tree().get_first_node_in_group("Player") as Player)
	if player:
		player.global_position = wall_tile_map.getPlayerSpawnPosition()
	
	for foodSpawnerPos in wall_tile_map.getFoodSpawnerPositions():
		var newFoodSpawner = foodSpawner.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		(newFoodSpawner as FoodSpawner).global_position = foodSpawnerPos
		add_sibling.call_deferred(newFoodSpawner)
		print("Spawned Food Source: ", foodSpawnerPos)
	
	for enemySpawnerPos in wall_tile_map.getEnemySpawnerPositions():
		print("Spawned Enemy Base: ", enemySpawnerPos)
	pass
