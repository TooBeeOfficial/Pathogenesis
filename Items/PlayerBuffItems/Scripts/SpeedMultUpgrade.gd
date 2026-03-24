extends BasePlayerBuff

@export var speedMultiplier = 1.05

func applyBuff(_player:Player):
	_player.BaseCombat.speed *= speedMultiplier
