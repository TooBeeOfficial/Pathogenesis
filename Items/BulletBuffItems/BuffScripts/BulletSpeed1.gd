extends BaseItem

@export var bulletSpeed:float  = 50

func applyItemEffect(bullet:BaseBullet):
	bullet.bulletStats.bulletSpeed += bulletSpeed
	#print_debug(bullet.bulletStats.bulletSpeed)
	pass
