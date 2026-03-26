extends CharacterBody2D
class_name Enemy

@export var BaseCombat:EnemyCombatFunctionality

@onready var BurnEffectCPU_Particle := $BurnEffect
@onready var HitCPU_Particle := $HitParticle
@onready var HitEffectAnimationPlayer := $EnemyAnimations
@onready var BulletSpawnLocation := $BulletSpawnLocation

var FoodScene := load("res://Scenes/Food.tscn").duplicate(true)

func OnDeath():
	collision_mask = 0
	collision_layer = 0
	BurnEffectCPU_Particle.emitFlame(false)
	await HitEffectAnimationPlayer.animation_finished
	HitEffectAnimationPlayer.play("DeathAnimation")
	await HitEffectAnimationPlayer.animation_finished
	HitCPU_Particle.emitting = true
	await  HitCPU_Particle.finished
	var newFood = (FoodScene.instantiate() as Food)
	newFood.portalFuelmount = ceili(BaseCombat.MaxHealth / 100)
	add_sibling(newFood)
	newFood.global_position = global_position
	newFood.foodColor = Color.from_rgba8(100,0,0,255)
	print_debug("ENEMY FOOD DROP: ",newFood.portalFuelmount)
	newFood.UpdateColors()
	queue_free()

func takeDamage(amount):
	if BaseCombat.isHittable == true:
		HitCPU_Particle.emitting = true
		BaseCombat.TakeDamage(amount,self)
		HitEffectAnimationPlayer.play("HitAnimation")

func OnCollision(body: Node) -> void:
	if body is Player:
		body.takeDamage(BaseCombat.contactDamage)

func tryEmitFlame(enableBurnEffect:bool) ->void:
	BurnEffectCPU_Particle.emitFlame(enableBurnEffect)
