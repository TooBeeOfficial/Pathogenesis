extends CombatFunctionality

class_name EnemyCombatFunctionality

# enemy depended stat
@export var contactDamage = 5

# To change enemy on run time
@export var collisionshape:Shape2D
@export var collisionTransform:Transform2D
@export var enemySprite: Texture2D
@export var canEnemyShoot:bool = false

# rarity for waves
# -1 = never (special spawn case)
# 0 = always
# 10 = after 10 waves
@export var EnemySpawnWave:int = 0
