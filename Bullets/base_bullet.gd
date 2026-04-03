extends CharacterBody2D

class_name BaseBullet

@export var bulletStats:BaseBulletStats
@export var collisionShape:CollisionShape2D
@export var BulletEffects:Array[BulletEffect]
var bulletDirection = Vector2.RIGHT.rotated($".".rotation)
var _colorMult:int = 6

var player
var newRotation
var isPlayer := false

var StopColliding = false

@onready var BaseBulletSprite2D := $Sprite2D
@onready var BaseBulletDurationTimer := $LifeSpan
@onready var BaseBulletTrackingRange := $TrackingRange
@onready var BulletHitParticle := $BulletHitParticle

func _ready() -> void:
	initBullet()

func initBullet():
	bulletStats = bulletStats.duplicate()
	if bulletStats.sprite:
		BaseBulletSprite2D.texture = bulletStats.sprite
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	if isPlayer == true:
		global_rotation = (player as Player).global_rotation
		newRotation = Vector2.RIGHT.rotated((player as Player).global_rotation)
		velocity = newRotation.normalized() * bulletStats.bulletSpeed * bulletStats.bulletSpeedMult
	elif isPlayer == false:
		look_at((player as Player).global_position)
		newRotation = Vector2.RIGHT.rotated(global_rotation)
		velocity = newRotation.normalized() * bulletStats.bulletSpeed * bulletStats.bulletSpeedMult
	BaseBulletDurationTimer.wait_time = bulletStats.BulletLifeSpan
	BaseBulletDurationTimer.start()
	UpdateCollisionMask(isPlayer)
	GameSfx.playPlayerShoot()

func _enter_tree() -> void:
	bulletStats.OnBulletSpawn.emit(self)

func UpdateCollisionMask(isBulletFromPlayer: bool = true):
	isPlayer = isBulletFromPlayer
	if isPlayer:
		# Put bullet on PlayerBullet layer (3)
		set_collision_layer_value(3, true)
		set_collision_layer_value(4, false)
		# Player bullet should hit Enemies (2) and Wall (5)
		set_collision_mask_value(2, true)    # Enemy
		set_collision_mask_value(1, false)   # Don't hit player
		set_collision_mask_value(5, true)    # Walls / World
	else:
		# Put bullet on EnemyBullet layer (4)
		set_collision_layer_value(3, false)
		set_collision_layer_value(4, true)
		# Enemy bullet should hit Player (1) and Wall (5)
		set_collision_mask_value(1, true)    # Player
		set_collision_mask_value(2, false)   # Don't hit enemy
		set_collision_mask_value(5, true)    # Walls / World

func calculateColor():
	if BaseBulletSprite2D != null and bulletStats.bulletDamage * bulletStats.bulletDamageMult > 12:
		var calRed = clamp(bulletStats.bulletDamage * bulletStats.bulletDamageMult * _colorMult, 0, 255) / 255
		BaseBulletSprite2D.modulate = Color(calRed,0,0,1)

func calcBulletDamage() -> int:
	return ceil(bulletStats.bulletDamage * bulletStats.bulletDamageMult)

func applyBulletEffects(body):
	if not body:
		return
	for effect in BulletEffects:
		await effect.applyBulletEffect(body,get_parent().get_tree())

func bulletCollided(body: Node) -> void:
	bulletStats.OnBulletCollision.emit()
	if StopColliding == true:
		return
	GameSfx.playEnemyGotHit()
	# to avoid hitting self enemy
	if body is Player or body is Enemy:
		body.takeDamage(calcBulletDamage())
		applyBulletEffects(body)
	# will target next in trackRange
	# disable tracking bullet
	# so it won't bounce of to the other target
	if bulletStats.isRichochetBulletOn == false:
		bulletStats.isTrackingBulletOn = false
	elif bulletStats.isRichochetBulletOn == true:
		#BounceBullet(get_last_slide_collision())
		RicochetBullet()
	bulletStats.trackingBody = null
	if bulletStats.isBouncyBulletOn and bulletStats.isRichochetBulletOn:
		if  bulletStats.currentBounce > bulletStats.HowManyTimesToBounce and  bulletStats.currentRichochet > bulletStats.RichochetAmount:
				BulletHitParticle.emitting = true
				OnBulletLifeEnd()
				return
	if bulletStats.isBouncyBulletOn:
		bulletStats.currentBounce += 1
		if  bulletStats.currentBounce > bulletStats.HowManyTimesToBounce:
			BulletHitParticle.emitting = true
			OnBulletLifeEnd()
	elif bulletStats.isRichochetBulletOn:
		bulletStats.currentRichochet += 1
		if  bulletStats.currentRichochet > bulletStats.RichochetAmount:
			BulletHitParticle.emitting = true
			OnBulletLifeEnd()
	else:
		BulletHitParticle.emitting = true
		OnBulletLifeEnd()
	return

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity.normalized() * bulletStats.bulletSpeed  * bulletStats.bulletSpeedMult* delta)
	if collision != null:
		bulletCollided(collision.get_collider())
	# always go forward
	BounceBullet(collision)
	TrackEnemy()
	look_at(velocity)

func BounceBullet(collision):
	if !bulletStats.isBouncyBulletOn or collision == null:
		return
	# calculate and rotate to angle
	velocity = velocity.bounce(collision.get_normal())
	rotate(velocity.angle())
	if bulletStats.trackingBody and bulletStats.isTrackingBulletOn:
		bulletStats.trackingBody = null

func TrackEnemy():
	if !bulletStats.isTrackingBulletOn or bulletStats.trackingBody == null:
		return
	if velocity.length() == 0:
		velocity = Vector2.RIGHT.rotated(rotation) * bulletStats.bulletSpeed * bulletStats.bulletSpeedMult
	var targetDir = (bulletStats.trackingBody.global_position - global_position).normalized()
	velocity = targetDir * bulletStats.bulletSpeed * bulletStats.bulletSpeedMult
	if !bulletStats.isBouncyBulletOn:
		rotation = targetDir.angle()

func OnBodyEnteredTrackingRange(body: Node2D) -> void:
	if bulletStats.trackingBody == null and body is Enemy:
		bulletStats.trackingBody = body

func OnTrackedBodyExitTrackingRange(_body: Node2D) -> void:
	if bulletStats.trackingBody != null and _body is Enemy:
		bulletStats.trackingBody = null

func OnBulletLifeEnd() -> void:
	if self:
		StopColliding = true
		BaseBulletSprite2D.visible = false
		await BulletHitParticle.finished
		queue_free()

func RicochetBullet():
	if !bulletStats.isRichochetBulletOn:
		return
	# if enemy inside Track Range go to next enemy
	for body in BaseBulletTrackingRange.get_overlapping_bodies():
		# not the same body that its already collided
		if bulletStats.trackingBody != body:
			if bulletStats.trackingBody:
				self.add_collision_exception_with(bulletStats.trackingBody)
			bulletStats.isTrackingBulletOn = true
			bulletStats.isBouncyBulletOn = true
			bulletStats.trackingBody = body
			return
	bulletStats.isTrackingBulletOn = true
	bulletStats.isBouncyBulletOn = true
