extends CharacterBody2D
class_name Player

@warning_ignore_start("unused_signal")

# combat stats and functionality
@export var BaseCombat:CombatFunctionality
# used for movement, instead of only clicking
# player can also hold to go to the destination
var isMouseHeld = false
# once player reaches threshold ex. 100 spawn a location portal
var portalSpawnPercent = 0
# used for movement and movement animation
var isMoving: bool = false
# Scales used for animation
@export var MaxScale = 2.7
@export var MinScale = 2.3
# on start reset scale in case changed
const NormalScale = 2.5
# Used for tween animation for apendages of enemy
var baseScale = Vector2(MinScale, MinScale)
var pulseScale = Vector2(MaxScale, MaxScale)
var pulseDuration = 1
var tween
# For spawning new locations
@export var Location: PackedScene
@export var LocationSpawnRadius = 500
@export var LocationMinSapwnDistance = 250
# when hit camera shake
@export var randomShakeStrengh = 50
@export var shakeFade = .3
var randomNumberForShake = RandomNumberGenerator.new()
var shakeStrengh = 0

# To make the code more readible
@onready var CPUparticleHitEffect := $HitParticle
@onready var EyeFrameTimer := $EyeFrames
@onready var HitAnimationPlayer := $HitAnimationPlayer
@onready var BulletSpawnNodeLocation := $BulletSpawnLocation
@onready var PlayerCamera := $Sprite2D/Camera2D

signal PlayerTookDamageUpdateHealthBar(Health:float, MaxHealth:float)
signal PlayerShoot(bulletSpawnPosition:Vector2)
signal PlayerEyeFrameEnd
signal PlayerAteFood
signal onHealthChanged(Health:float, MaxHealth:float)

signal PlayerTookItemOrBuff(PlayerEnumBuffName:int)
signal OpenBuffMenu(visibility:bool)

func _init() -> void:
	scale.y = NormalScale
	scale.x = NormalScale

func addUpgrade(upgrade:BaseItem):
	BaseCombat.bulletUpgrades.append(upgrade)
	emit_signal(SignalNamesList.PlayerTookItemOrBuff)

# adds it to upgrade list in case we change scenes
# applies the buff immidietly
func addPlayerBuff(buff:BasePlayerBuff):
	BaseCombat.playerBuffs.append(buff)
	await buff.applyBuff(self)
	emit_signal(SignalNamesList.PlayerTookItemOrBuff)

# start animation pulse
func _start_pulsing():
	tween = get_tree().create_tween()
	tween.set_loops()
	# animation goes from minimum scale to maximum scale
	# then goes backwards
	tween.tween_property(self, "scale", pulseScale, pulseDuration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", baseScale, pulseDuration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# reset strengh
func ShakeCamera():
	shakeStrengh = randomShakeStrengh

func _stop_pulsing(resetScale:bool):
	if tween:
		tween.kill()
		# reset scales while moving
		if resetScale == true:
			scale = Vector2(NormalScale,NormalScale)
		elif resetScale == false:
			scale = Vector2(MaxScale,MinScale)

# Used for gameplay loop to create a new portal once threshold is reached
func IncrementPortalSpawnPercent(amount):
	emit_signal("PlayerAteFood")
	portalSpawnPercent += amount
	GameSfx.playPlayerAteFood()
	# max portal amount cant exceed threshold
	# once it exceeds spawn portal and keep exceeding amount
	if portalSpawnPercent >= 100:
		# Keep Exceeding fuel source
		portalSpawnPercent = portalSpawnPercent - 100
		# initialize new pawning location and its initial position range
		var newLocation = Location.instantiate()
		var newPosition = Vector2(randi_range(-LocationSpawnRadius,LocationSpawnRadius), randi_range(-LocationSpawnRadius,LocationSpawnRadius))
		# Spawn LocationMinSapwnDistance away from player characters current position
		if abs(newPosition.x) < LocationMinSapwnDistance:
			newPosition.x = LocationMinSapwnDistance * sign(newPosition.x)
		if abs(newPosition.y) < LocationMinSapwnDistance:
			newPosition.y = LocationMinSapwnDistance * sign(newPosition.y)
		# Add players global position to make it spawn around player
		# instead of root scene
		newPosition += global_position
		newLocation.global_position = newPosition
		call_deferred("add_sibling", newLocation)
		OpenBuffMenu.emit(false)

# reduce "food"
func DecrementPortalSpawnPercent(amount):
	portalSpawnPercent -= amount
	if portalSpawnPercent <= 0:
		# prevent portal from going into negatives
		portalSpawnPercent = 0

func OnDeath():
	pass

func HealPlayer(healAmount:float):
	BaseCombat.Heal(healAmount)
	onHealthChanged.emit(BaseCombat.health,BaseCombat.MaxHealth)

func takeDamage(amount):
	if BaseCombat.isHittable == true:
		# activate hit effectand start timer
		CPUparticleHitEffect.emitting = true
		BaseCombat.TakeDamage(amount,self)
		onHealthChanged.emit(BaseCombat.health,BaseCombat.MaxHealth)
		EyeFrameTimer.start()
		HitAnimationPlayer.play("HitEffect")
		GameSfx.playPlayerGotHit()

# called by timer timeout signal
# used for adding eye frames
func EyeFrameEnd():
	BaseCombat.isHittable = true
	emit_signal("PlayerEyeFrameEnd")

# used to create camera shake effect
func randomOffset() -> Vector2:
	return Vector2(randomNumberForShake.randf_range(-shakeStrengh,shakeStrengh),randomNumberForShake.randf_range(-shakeStrengh,shakeStrengh))

func _physics_process(delta: float) -> void:
	if BaseCombat.shoot_cooldown > 0:
		BaseCombat.shoot_cooldown -= delta
	elif Input.is_action_pressed("Shoot"):
		if BaseCombat.shoot_cooldown<=0:
			emit_signal("PlayerShoot")
			#HitAnimationPlayer.play("Shoot")
			GameSfx.playPlayerShoot()
			BaseCombat.spawnBullet(BulletSpawnNodeLocation.global_position,true,self)
	# > 0 apply shake and slowly fade it out
	if shakeStrengh > 0:
		shakeStrengh = lerpf(shakeStrengh,0,shakeFade + delta)
		PlayerCamera.offset += randomOffset()
	# if camera is out of position and shake animation finished reset its offset
	if (PlayerCamera.offset as Vector2).length() > 0 and shakeStrengh <= 0.01:
		PlayerCamera.offset = Vector2.ZERO
	# 8 way movement
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	isMoving = !input_direction.is_zero_approx()
	velocity = input_direction * BaseCombat.speed
	# player looks at mouse for immersion
	look_at(get_global_mouse_position())
	move_and_slide()
