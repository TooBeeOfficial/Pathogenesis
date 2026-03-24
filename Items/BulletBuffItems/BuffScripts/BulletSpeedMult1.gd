extends BaseItem

@export var bulletSpeedMult:float  = 1.5

func applyItemEffect(bullet:BaseBullet):
	bullet.bulletStats.bulletSpeedMult *= bulletSpeedMult
	#print_debug(bullet.bulletStats.bulletSpeedMult)
	pass
