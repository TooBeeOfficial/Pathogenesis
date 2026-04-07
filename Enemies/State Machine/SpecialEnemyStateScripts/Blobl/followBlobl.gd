extends EnemyFolow

func EnterState():
	super.EnterState()
	playerLastSeen = Vector2()
	pass

func ExitState():
	pass

func Update(_delta: float) -> void:
	pass

func PhysicsUpdate(_delta: float) -> void:
	var collided = attachedEnemy.move_and_collide(attachedEnemy.velocity * _delta)
	if collided:
		attachedEnemy.OnCollision(collided.get_collider())
	var direction = player.global_position - attachedEnemy.global_position
	if direction.length() < 350:
		attachedEnemy.velocity = direction.normalized() * attachedEnemy.BaseCombat.speed
		
		if attachedEnemy.velocity.length() > .1:
			attachedEnemy.rotation = lerp_angle(attachedEnemy.rotation, attachedEnemy.velocity.angle(), 0.1)
		playerLastSeen = player.global_position
		
	if attachedEnemy.BaseCombat.canEnemyShoot == true and direction.length() >= 150 and attachedEnemy.BaseCombat.shoot_cooldown < 0:
		var bulletSpawnLocation = attachedEnemy.BulletSpawnLocation
		attachedEnemy.BaseCombat.spawnBullet(bulletSpawnLocation.global_position,false,bulletSpawnLocation,attachedEnemy.global_position)
		attachedEnemy.BaseCombat.shoot_cooldown = 2
	else:
		attachedEnemy.BaseCombat.shoot_cooldown -= _delta
	# chase player until last seen location
	# if enemy isn't in view switch to IDLE state
	if direction.length() > 600:
		attachedEnemy.velocity = (playerLastSeen - attachedEnemy.global_position).normalized() * attachedEnemy.BaseCombat.speed
		if attachedEnemy.velocity.length() > .1:
			attachedEnemy.rotation = attachedEnemy.velocity.angle()
		if (playerLastSeen - attachedEnemy.global_position).length() <= 250:
			TransitionStateSignal.emit($"../IDLE")
