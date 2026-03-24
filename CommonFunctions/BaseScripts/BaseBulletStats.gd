extends Resource

class_name BaseBulletStats

@warning_ignore("unused_private_class_variable")
@warning_ignore_start("unused_signal")

# Alter bullet sprite
@export var sprite: Texture2D

# Main Bullet Stats
@export var bulletDamage:float = 5
@export var bulletSpeed:float = 300
@export var bulletDamageMult:float = 1
@export var bulletSpeedMult:float = 1
@export var BulletLifeSpan:float = 5.0

# Different bullet Interactions
# Bounce
@export var isBouncyBulletOn:bool = false
var HowManyTimesToBounce:int = 3
var BounceOfOtherBullets:bool = false
var currentBounce:int = 0

# Richochet
@export var isRichochetBulletOn:bool = false
var RichochetAmount:int = 2
var currentRichochet:int = 0

# Tracking
@export var isTrackingBulletOn:bool= false
var TrackingBulletTrackMultiplier:float = 1.0
var trackingBody:Node

signal OnBulletCollision(collidedNode:Node)
signal OnBulletSpawn(_bullet:BaseBullet)
