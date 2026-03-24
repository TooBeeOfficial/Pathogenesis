extends PlayerBaseTimerItem

@export var FireRate = 5

func applyBuff(_player:Player):
	_player.BaseCombat.fireRate += FireRate
	super.applyBuff(_player)

func applyTimerEffect(_player:Player):
	_player.BaseCombat.fireRate -= FireRate/300.0
	_player.PlayerTookItemOrBuff.emit()
