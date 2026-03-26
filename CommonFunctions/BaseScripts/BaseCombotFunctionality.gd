extends Resource
class_name CombatFunctionality

# Base stats for Combat
# upgradable stats
@export var MaxHealth := 50.0
@export var speed := 200.0
# higher value means more bullets
@export var fireRate := 2.5
@export var armor := 0.0
# variable stats
@export var health := 50.0
@export var shoot_cooldown:float= 0.0
# Player buff items
@export var playerBuffs:Array[BasePlayerBuff] = []
# bullet to shoot, Modular
var bulletUpgrades:Array[BaseItem] = []
@export var bulletScene: PackedScene

var isHittable = true
var isBurning = false

# max = maximum damage reduction
# EX. 0.3 = 70 % max damage reduction
const MAX_ARMOR_REDUCTION = 0.3
const MIN_ARMOR_REDUCTION = 1

func Heal(healAmount:float):
	health = clampf(health + healAmount,-1,MaxHealth)

func takeDamageWithArmor(DamageTaken):
	return clampf(100 / (100 + armor),MAX_ARMOR_REDUCTION, MIN_ARMOR_REDUCTION) * DamageTaken

func TakeDamage(amount: int, character:Node2D):
	# if character doesnt eyeframes
	if isHittable == true:
		health -= takeDamageWithArmor(amount)
		# only player will have eye frames
		if character is Player:
			isHittable = false
		
		if character is Enemy:
			# If Player has burning bullets activate flame on enemy
			if isBurning == true:
				character.tryEmitFlame(true)
			elif isBurning == false:
				character.tryEmitFlame(false)
		# on death call characters' death function
		if health <= 0:
			character.OnDeath()

func spawnBullet(bulletSpawnLocation:Vector2,isPlayer,spawnNode: Node2D):
	
	var bullet = bulletScene.duplicate_deep(Resource.DEEP_DUPLICATE_ALL).instantiate()
	var bulletAsBaseBullet = (bullet as BaseBullet)
	
	for upgrade in bulletUpgrades:
		if upgrade is BulletEffect:
			bulletAsBaseBullet.BulletEffects.append(upgrade)
		# Seperate Player item uprades from BulletEffect upgrades
		upgrade.applyItemEffect(bulletAsBaseBullet)
	bulletAsBaseBullet.isPlayer = isPlayer
	
	spawnNode.add_sibling(bulletAsBaseBullet)
	bulletAsBaseBullet.global_position = bulletSpawnLocation
	# used for collision detection
	# does not collide with the firing character
	bulletAsBaseBullet.calculateColor()
	# add a cap to firerate
	shoot_cooldown = clampf(2.0/fireRate,0.05,50.0)
