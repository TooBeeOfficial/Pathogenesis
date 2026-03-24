extends BasePlayerBuff

@export var health = 5
@export var speed = 5

func applyBuff(_player:Player):
	_player.BaseCombat.speed += speed
	_player.BaseCombat.MaxHealth += health
