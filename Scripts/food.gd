extends Area2D

class_name Food
# default amount used to charge portal
var portalFuelmount:int = 5
var isEaten = false
var finalPosition:Vector2 = Vector2.ZERO
@export var duration: float = .5
@export var foodColor:Color

@onready var FoodSprite := $Sprite2D
@onready var FoodOnEatCPU_Particle := $FoodEatenParticle

const FOOD_SCALE_OFFSET_UPPER := .4
const FOOD_SCALE_OFFSET_LOWER := .1
const FOOD_FUEL_MULT = 10
const FOOD_ROTATION_MIN = 0
const FOOD_ROTATION_MAX = 360

func _ready() -> void:
	var newScale = randf_range(-FOOD_SCALE_OFFSET_LOWER,FOOD_SCALE_OFFSET_UPPER)
	scale.x += newScale
	scale.y += newScale
	portalFuelmount += snappedi(newScale * FOOD_FUEL_MULT, 1)
	rotation = randf_range(FOOD_ROTATION_MIN,FOOD_ROTATION_MAX)

func setFinalDestinationPoint(newPos:Vector2) -> void:
	finalPosition = newPos
	var tween = create_tween()
	tween.tween_property(self, "position",finalPosition,duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func OnBodyEneter(body: Node) -> void:
	if body is Player:
		body.IncrementPortalSpawnPercent(portalFuelmount)
		FoodOnEatCPU_Particle.emitting = true
		isEaten = true;
		
	if isEaten == true:
		SignalManager.updateScore.emit(portalFuelmount * 5)
		await get_tree().create_timer(FoodOnEatCPU_Particle.lifetime+.05).timeout
		queue_free()

func UpdateColors():
	FoodOnEatCPU_Particle.color = foodColor
	(FoodSprite as Sprite2D).modulate = foodColor
