extends BasePlayerBuff

@export var fireRate:float = 1
@export var damage:float = 2

func applyItemEffect(_bullet:BaseBullet):
	_bullet.bulletStats.bulletDamage += damage

func applyBuff(player:Player):
	player.BaseCombat.fireRate += fireRate
	pass
