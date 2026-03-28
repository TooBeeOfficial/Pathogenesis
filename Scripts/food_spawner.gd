extends StaticBody2D
class_name FoodSpawner
var currentFoodSpawned = 0
# used for checking how much time has passed and if spawner needs to spawn food
var time_elapsed = 0
var isPlayerInArea = false
# Maximum range to spawn the food items
@export var SpawnRadius = 100
@export var SpawnMargin = 50
@export var FoodScene: PackedScene
# Used for "animating" the food spawning animation
@export var minScale = 1.9
@export var maxScale = 2.1

@onready var foodSpawnerSprite := $Sprite2D
const MAXIMUM_FOOD_SPAWN = 10
const IMAGE_COLOR_MIN_VALUE = 40
const IMAGE_COLOR_MAX_VALUE = 70
const BASE_SCALE = 2

@export var foodList:Array[Texture]

func _ready() -> void:
	if !foodList.is_empty():
		foodSpawnerSprite.texture = foodList.pick_random()
	rotation = randf_range(0,360)

func ExtractFoodColor()->Color:
	var image:Image = foodSpawnerSprite.texture.get_image()
	var color = image.get_pixel(randi_range(IMAGE_COLOR_MIN_VALUE,IMAGE_COLOR_MAX_VALUE),randi_range(IMAGE_COLOR_MIN_VALUE,IMAGE_COLOR_MAX_VALUE))
	return color

func _process(delta: float) -> void:
	if isPlayerInArea:
		time_elapsed += delta
		scale = Vector2((lerpf(BASE_SCALE,minScale,time_elapsed) as float),(lerpf(BASE_SCALE,minScale,time_elapsed as float)))
		if time_elapsed > 1 and MAXIMUM_FOOD_SPAWN != currentFoodSpawned:
			# increment to check if spawner needs to be destroyed/freed
			currentFoodSpawned += 1
			# reset timer for every second to prevent from spawning food too early
			time_elapsed = 0
			scale = Vector2(lerpf(BASE_SCALE,maxScale,time_elapsed),lerpf(BASE_SCALE,maxScale,time_elapsed))
			# spawn food
			var newFood = FoodScene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
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
			newFood.global_position = global_position
			(newFood as Food).setFinalDestinationPoint(spawnPosition)
			# print_debug(newFood.position - global_position)
			# adds it a a sibling to not be effected by the scale changes
			add_sibling(newFood)
			# adjust food color
			(newFood as Food).foodColor = ExtractFoodColor()
			(newFood as Food).UpdateColors()
		if MAXIMUM_FOOD_SPAWN == currentFoodSpawned:
			# Destroy spawner
			if self:
				queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	isPlayerInArea = true
	$WaypointMarker.visible = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$WaypointMarker.visible = true
