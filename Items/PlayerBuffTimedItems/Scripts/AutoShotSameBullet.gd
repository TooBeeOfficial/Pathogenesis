extends PlayerBaseTimerItem

func applyBuff(_player:Player):
	super.applyBuff(_player)

func applyTimerEffect(_player:Player):
	var spawnLocation = _player.BulletSpawnNodeLocation.global_position
	_player.BaseCombat.spawnBullet(spawnLocation,true,_player)
