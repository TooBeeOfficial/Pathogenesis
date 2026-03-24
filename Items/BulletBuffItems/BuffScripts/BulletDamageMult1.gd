extends BaseItem

@export var DamageMult:float  = 1.5

func applyItemEffect(bullet:BaseBullet):
	bullet.bulletStats.bulletDamageMult *= DamageMult
	#print_debug(bullet.bulletStats.bulletDamageMult)
	pass
