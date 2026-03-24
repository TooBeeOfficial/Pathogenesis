extends BasePlayerBuff
class_name PlayerSpeedBuff

@export var speed:int = 50

func applyBuff(player:Player):
	player.BaseCombat.speed += speed
	pass
