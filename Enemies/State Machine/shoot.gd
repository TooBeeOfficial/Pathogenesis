extends BaseState
class_name EnemyShoot

func EnterState():
	super.EnterState()
	pass

func ExitState():
	pass

func PhysicsUpdate(_delta: float) -> void:
	attachedEnemy.look_at(player.global_position)
	var direction = player.global_position - attachedEnemy.global_position
	if direction.length()<300:
		TransitionStateSignal.emit($"../FOLLOW")
	if attachedEnemy.BaseCombat.shoot_cooldown > 0:
		attachedEnemy.BaseCombat.shoot_cooldown -= _delta
	else:
		var bulletSpawnLocation = attachedEnemy.BulletSpawnLocation.global_position
		attachedEnemy.BaseCombat.spawnBullet(bulletSpawnLocation,false,attachedEnemy)
	pass

func Update(_delta: float) -> void:
	pass
