extends BaseItem

@export var damage:float = 3

func applyItemEffect(bullet:BaseBullet):
	bullet.bulletStats.bulletDamage += damage
	#print_debug(bullet.bulletStats.bulletDamage)
	pass
