extends BasePlayerBuff
class_name ArmorUpgrade

@export var Armor = 5

func applyBuff(_player:Player):
	_player.BaseCombat.armor += Armor
