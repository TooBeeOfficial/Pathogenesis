extends Node

@onready var obstacle_spawner = $ObstacleSpawner
@onready var wall_tile_map = $WallTileMap
var foodSpawner = preload("res://Scenes/FoodSpawner.tscn")
var enemySpawner = preload("res://Scenes/EnemySpawner.tscn")
var wave = 0

func _ready() -> void:
	obstacle_spawner.connect("GeneratedNoise",OnFinishNoise)
	wall_tile_map.connect("FinishedPlacingTiles", OnFinishWallPlacement)
	SignalManager.connect("generateNewMap",newClassicMap)
	newClassicMap(MapGenerationSettings.mapList[MapGenerationSettings.mapNameList[0]])

func newClassicMap(settings:MapGenerationSettings.MapSettings):
	# Queue currently spawned entities for emptying map
	var spawners = get_tree().get_nodes_in_group("Spawner")
	#print_debug((spawners as Array).size())
	for spawner in spawners:
		spawner.queue_free()
	
	var locations = get_tree().get_nodes_in_group("Location")
	#print_debug((locations as Array).size())
	for location in locations:
		location.queue_free()
	
	var enemies = get_tree().get_nodes_in_group("Enemy")
	#print_debug((enemies as Array).size())
	for enemy in enemies:
		enemy.queue_free()
	
	var foods = get_tree().get_nodes_in_group("Enemy")
	#print_debug((foods as Array).size())
	for food in foods:
		food.queue_free()
	
	# wait for the next frame to free every entity before spawning new map
	await get_tree().process_frame
	
	obstacle_spawner.clearForNewMap()
	obstacle_spawner.currentMapSettings = settings
	obstacle_spawner.GenerateAndClean()

# spawns map after procedurally generating the noise
func OnFinishNoise():
	wall_tile_map.obstacleMap = obstacle_spawner.colors
	wall_tile_map.size = obstacle_spawner.NoiseSize
	wall_tile_map.PlaceTiles(obstacle_spawner.getPlayableArea(),obstacle_spawner.colors)

func OnFinishWallPlacement():
	var player = (get_tree().get_first_node_in_group("Player") as Player)
	if player:
		player.global_position = wall_tile_map.getPlayerSpawnPosition()
	
	for foodSpawnerPos in wall_tile_map.getFoodSpawnerPositions():
		var newFoodSpawner = foodSpawner.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		(newFoodSpawner as FoodSpawner).global_position = foodSpawnerPos
		add_sibling(newFoodSpawner)
		# print("Spawned Food Source: ", foodSpawnerPos)
	
	for enemySpawnerPos in wall_tile_map.getEnemySpawnerPositions():
		var newEnemySpawner = enemySpawner.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		(newEnemySpawner as EnemySpawner).global_position = enemySpawnerPos
		(newEnemySpawner as EnemySpawner).setWave(wave)
		add_sibling(newEnemySpawner)
		# print("Spawned Enemy Base: ", enemySpawnerPos)
	increaseWave()

func increaseWave():
	wave += 1
