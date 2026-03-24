extends BasePlayerBuff
class_name PlayerHealthBuff

@export var maxHealth = 5

func applyBuff(player:Player):
	player.BaseCombat.MaxHealth += maxHealth
	player.HealPlayer(maxHealth)
	pass
