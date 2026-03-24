extends BaseState
class_name EnemyIdle

var moveDirection: Vector2
var wanderDuration: float

func RandomizeIdleMovement():
	wanderDuration = randf_range(2,4)
	moveDirection = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()

func EnterState():
	super.EnterState()
	RandomizeIdleMovement()

func Update(_delta: float) -> void:
	if wanderDuration > 0:
		wanderDuration -= _delta
	else:
		RandomizeIdleMovement()

func PhysicsUpdate(_delta: float) -> void:
	if attachedEnemy:
		attachedEnemy.velocity = moveDirection * attachedEnemy.BaseCombat.speed / 4
		attachedEnemy.move_and_slide()

		if attachedEnemy.velocity.length() > 0.1:
			attachedEnemy.rotation = attachedEnemy.velocity.angle()

		var direction = player.global_position - attachedEnemy.global_position
		if direction.length() < 350:
			TransitionStateSignal.emit($"../FOLLOW")
