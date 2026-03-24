extends BasePlayerBuff

@export var fireRate:float = 1
@export var bulletSpeed:float = 15

func applyItemEffect(_bullet:BaseBullet):
	_bullet.bulletStats.bulletSpeed += bulletSpeed

func applyBuff(player:Player):
	player.BaseCombat.fireRate += fireRate
	pass
