extends BasePlayerBuff
class_name PlayerFireRateBuff

@export var fireRate:float  = 1

func applyBuff(player:Player):
	player.BaseCombat.fireRate += fireRate
	pass
