extends PlayerBaseTimerItem
class_name HealthRegeneration

@export var healPerSecond = 1

func applyBuff(_player:Player):
	super.applyBuff(_player)

func applyTimerEffect(_player:Player):
	if randi_range(1,100) > 50:
		_player.HealPlayer(healPerSecond)
