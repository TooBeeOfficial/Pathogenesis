extends StaticBody2D
class_name EnemySpawner

var currentEnemySpawned = 0
# used for checking how much time has passed and if spawner needs to spawn food
var time_elapsed = 0
var isPlayerInArea = false
# Maximum range to spawn the food items
@export var SpawnRadius = 100
@export var SpawnMargin = 50
@export var EnemyScene: PackedScene

# Used for "animating" the food spawning animation
@export var minScale = 1.9
@export var maxScale = 2.1

@onready var foodSpawnerSprite := $Sprite2D
const MAXIMUM_ENEMY_SPAWN = 10
const BASE_SCALE = 2

func _ready() -> void:
	rotation = randf_range(0,360)

func onPlayerEntered(body):
	if body is Player:
		isPlayerInArea = true

func _process(delta: float) -> void:
	if isPlayerInArea:
		time_elapsed += delta
		scale = Vector2((lerpf(BASE_SCALE,minScale,time_elapsed) as float),(lerpf(BASE_SCALE,minScale,time_elapsed as float)))
		if time_elapsed > 1 and MAXIMUM_ENEMY_SPAWN != currentEnemySpawned:
			# increment to check if spawner needs to be destroyed/freed
			currentEnemySpawned += 1
			# reset timer for every second to prevent from spawning food too early
			time_elapsed = 0
			scale = Vector2(lerpf(BASE_SCALE,maxScale,time_elapsed),lerpf(BASE_SCALE,maxScale,time_elapsed))
			# spawn food
			var newEnemyFromList = Enemies.enemies.pick_random().duplicate_deep(Resource.DEEP_DUPLICATE_ALL).instantiate()
			var spawnPosition = Vector2(randi_range(SpawnRadius * -1 ,SpawnRadius),randi_range(SpawnRadius * -1,SpawnRadius))
			# Clamp minimum values for negative and positive to -25 and 25 respectively
			# to prevent food spawning inside the spawner
			# regardless of sign(+/-) if x position is less then 25 make it 25 then multiply it with its sign
			if abs(spawnPosition.x) < SpawnMargin:
				spawnPosition.x = SpawnMargin * sign(spawnPosition.x)
			# regardless of sign(+/-) if y position is less then 25 make it 25 then multiply it with its sign
			if abs(spawnPosition.y) < SpawnMargin:
				spawnPosition.y = SpawnMargin * sign(spawnPosition.y)
			# make it spawn relative to the foodSpawner instead of parent
			spawnPosition += global_position
			newEnemyFromList.global_position = global_position
			# adds it a a sibling to not be effected by the scale changes
			add_sibling(newEnemyFromList)
		if MAXIMUM_ENEMY_SPAWN == currentEnemySpawned:
			# Destroy spawner
			if self:
				queue_free()
