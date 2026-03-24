extends Node2D

@export var shootTime = 5
var shootTimeOffset
const TIMER_SHOOT_OFFSET = 0.5

var timer := 0.0

@onready var MushroomShootCooldownTimer := $ShootCooldown
@onready var MushroomSprite2D := $Sprite2D
@onready var MushroomAttackCPU_Particle := $AttackParticle
@onready var MushroomAttackHitAreaCollision := $Area2D/CollisionShape2D

func _ready() -> void:
	MushroomShootCooldownTimer.wait_time = shootTime
	var newTimerOffset =  randf_range(-TIMER_SHOOT_OFFSET,TIMER_SHOOT_OFFSET)
	MushroomShootCooldownTimer.wait_time += newTimerOffset
	shootTime = newTimerOffset

func shootParticle():
	MushroomAttackCPU_Particle.emitting = true
	MushroomAttackHitAreaCollision.disabled = false

func disableCollision():
	MushroomAttackHitAreaCollision.disabled = true

func _process(delta):
	timer += delta
	if timer > shootTime:
		timer = 0.0  # Restart loop

	# Progress 0.0 → 1.0 over shoot_time seconds
	var progress = timer / shootTime
	MushroomSprite2D.material.set_shader_parameter("charge_progress", progress)
